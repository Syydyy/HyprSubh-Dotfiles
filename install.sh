#!/usr/bin/env bash
#
# install.sh — Instalador para o fork HyprSubh-Dotfiles (Syydyy)
# Testado para CachyOS / Arch Linux com GPU AMD.
#
# Uso:
#   ./install.sh            # instala normalmente (pede confirmação)
#   ./install.sh --dry-run  # só mostra o que seria feito, sem alterar nada
#   ./install.sh --yes      # pula a confirmação interativa
#
set -euo pipefail

# ---------- Config ----------
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
DRY_RUN=false
ASSUME_YES=false

MONITOR_NAME="DP-3"
MONITOR_MODE="1920x1080@165"
MONITOR_SCALE="1.00"

PACOTES_PACMAN=(hyprland kitty waybar rofi swaync swayosd hyprlock hypridle firefox
  noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-jetbrains-mono-nerd ttf-firacode-nerd otf-font-awesome)
PACOTES_AUR=(awww ttf-google-sans otf-geist-mono-nerd)

CONFIG_FOLDERS=(hypr kitty rofi swaync waybar)

# Temas do VSCodium usados pelo theme switcher (hypr/switchers/set-theme.sh)
# Formato: "nome-da-pasta-do-tema|extension-id|nome-exibido-do-theme"
VSCODE_THEMES=(
  "Gruvbox|jdinhlife.gruvbox|Gruvbox Dark Medium"
  "Catppuccin|Catppuccin.catppuccin-vsc|Catppuccin Mocha"
  "Onedark|zhuangtongfa.material-theme|One Dark Pro Darker"
  "Everforest|sainnhe.everforest|Everforest Night Hard"
  "Nord|arcticicestudio.nord-visual-studio-code|Nord"
  "Rose Pine|mvllow.rose-pine|Rosé Pine Moon"
)
# Emerald (Ravenwood Dark) e E-ink (baseline) não têm ID de extensão confirmado
# com confiança — ficam de fora da instalação automática (ver aviso no final).

# ---------- Helpers ----------
log()   { echo -e "\033[1;32m[+]\033[0m $1"; }
warn()  { echo -e "\033[1;33m[!]\033[0m $1"; }
err()   { echo -e "\033[1;31m[x]\033[0m $1" >&2; }
run()   {
    if $DRY_RUN; then
        echo "  (dry-run) $*"
    else
        eval "$@"
    fi
}

for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=true ;;
        --yes|-y)  ASSUME_YES=true ;;
        *) warn "Argumento desconhecido: $arg" ;;
    esac
done

# ---------- Checagens iniciais ----------
if [ ! -d "$REPO_DIR/hypr" ]; then
    err "Não encontrei a pasta 'hypr' em $REPO_DIR."
    err "Rode este script de dentro da pasta do repositório clonado (HyprSubh-Dotfiles)."
    exit 1
fi

if ! command -v pacman &>/dev/null; then
    err "pacman não encontrado. Este script é feito para Arch/CachyOS."
    exit 1
fi

AUR_HELPER=""
if command -v yay &>/dev/null; then
    AUR_HELPER="yay"
elif command -v paru &>/dev/null; then
    AUR_HELPER="paru"
else
    warn "Nenhum AUR helper (yay/paru) encontrado. Pacotes AUR (${PACOTES_AUR[*]}) serão pulados."
fi

echo
echo "=== Instalador HyprSubh-Dotfiles ==="
echo "Repositório:   $REPO_DIR"
echo "Destino:       $CONFIG_DIR"
echo "Backup em:     $BACKUP_DIR"
echo "Monitor alvo:  $MONITOR_NAME ($MONITOR_MODE)"
$DRY_RUN && warn "Modo DRY-RUN ativo: nada será alterado de fato."
echo

if ! $ASSUME_YES && ! $DRY_RUN; then
    read -rp "Continuar com a instalação? [s/N] " resp
    if [[ ! "$resp" =~ ^[sS]$ ]]; then
        echo "Cancelado."
        exit 0
    fi
fi

# ---------- 1. Backup ----------
log "Fazendo backup das configs existentes..."
run "mkdir -p '$BACKUP_DIR'"
for d in "${CONFIG_FOLDERS[@]}"; do
    if [ -d "$CONFIG_DIR/$d" ]; then
        run "cp -r '$CONFIG_DIR/$d' '$BACKUP_DIR/$d'"
        log "  Backup feito: $d"
    fi
done

# ---------- 2. Instalar pacotes ----------
log "Instalando pacotes via pacman..."
run "sudo pacman -S --needed --noconfirm ${PACOTES_PACMAN[*]}"

if [ -n "$AUR_HELPER" ]; then
    log "Instalando pacotes AUR via $AUR_HELPER..."
    run "$AUR_HELPER -S --needed --noconfirm ${PACOTES_AUR[*]}"
fi

# ---------- 3. Copiar configs ----------
log "Copiando arquivos de configuração para $CONFIG_DIR..."
run "mkdir -p '$CONFIG_DIR'"
for d in "${CONFIG_FOLDERS[@]}"; do
    run "cp -r '$REPO_DIR/$d' '$CONFIG_DIR/'"
    log "  Copiado: $d"
done

# A pasta themes/ fica na raiz do repo, mas os switchers esperam em hypr/themes
log "Corrigindo localização da pasta themes/ (raiz -> hypr/themes)..."
run "cp -r '$REPO_DIR/themes' '$CONFIG_DIR/hypr/themes'"

# ---------- 4. Permissões dos switchers ----------
log "Dando permissão de execução aos scripts de switchers..."
run "chmod +x '$CONFIG_DIR/hypr/switchers/'*.sh"

# ---------- 5. Ajustar env.lua para AMD ----------
ENV_LUA="$CONFIG_DIR/hypr/modules/env.lua"
if [ -f "$ENV_LUA" ]; then
    log "Ajustando env.lua para GPU AMD (removendo variáveis NVIDIA)..."
    if $DRY_RUN; then
        echo "  (dry-run) substituiria bloco Nvidia por variáveis AMD em $ENV_LUA"
    else
        # Remove o bloco "-- Nvidia" e as 3 linhas hl.env seguintes
        sed -i '/-- Nvidia/,+3d' "$ENV_LUA"
        cat >> "$ENV_LUA" <<'EOF'

-- AMD
hl.env("LIBVA_DRIVER_NAME", "radeonsi")
hl.env("VDPAU_DRIVER", "radeonsi")
hl.env("GBM_BACKEND", "dri")
EOF
    fi
else
    warn "env.lua não encontrado em $ENV_LUA, pulando ajuste de GPU."
fi

# ---------- 6. Ajustar monitors.lua ----------
MONITORS_LUA="$CONFIG_DIR/hypr/modules/monitors.lua"
if [ -f "$MONITORS_LUA" ]; then
    log "Ajustando monitors.lua para $MONITOR_NAME ($MONITOR_MODE)..."
    run "sed -i 's/eDP-1/$MONITOR_NAME/g' '$MONITORS_LUA'"
    run "sed -i 's/1920x1200@144/$MONITOR_MODE/g' '$MONITORS_LUA'"
    run "sed -i 's/scale    = \"1.20\"/scale    = \"$MONITOR_SCALE\"/g' '$MONITORS_LUA'"
else
    warn "monitors.lua não encontrado em $MONITORS_LUA, pulando ajuste de monitor."
fi

# ---------- 7. Recarregar Hyprland, se já estiver rodando ----------
if command -v hyprctl &>/dev/null && hyprctl version &>/dev/null; then
    log "Sessão Hyprland detectada, recarregando..."
    run "hyprctl reload"
else
    warn "Hyprland não está rodando agora. Faça logout e entre numa sessão Hyprland para aplicar tudo."
fi

# ---------- 8. Temas do VSCodium ----------
EDITOR_BIN=""
EDITOR_CONFIG_DIR=""
if command -v codium &>/dev/null; then
    EDITOR_BIN="codium"
    EDITOR_CONFIG_DIR="$CONFIG_DIR/VSCodium"
elif command -v code &>/dev/null; then
    EDITOR_BIN="code"
    EDITOR_CONFIG_DIR="$CONFIG_DIR/Code"
fi

if [ -n "$EDITOR_BIN" ]; then
    log "Instalando temas no $EDITOR_BIN..."
    for entry in "${VSCODE_THEMES[@]}"; do
        IFS='|' read -r theme_folder ext_id theme_name <<< "$entry"
        log "  Instalando extensão: $ext_id (tema: $theme_name)"
        run "$EDITOR_BIN --install-extension '$ext_id' --force" || warn "    Falha ao instalar $ext_id, confira o nome no Marketplace."
    done

    SETTINGS_JSON="$EDITOR_CONFIG_DIR/User/settings.json"
    log "Garantindo que $SETTINGS_JSON tenha a chave workbench.colorTheme..."
    if $DRY_RUN; then
        echo "  (dry-run) criaria/ajustaria $SETTINGS_JSON com workbench.colorTheme"
    else
        run "mkdir -p '$EDITOR_CONFIG_DIR/User'"
        if [ ! -f "$SETTINGS_JSON" ]; then
            echo '{
    "workbench.colorTheme": "Catppuccin Mocha"
}' > "$SETTINGS_JSON"
            log "    settings.json criado com tema padrão Catppuccin Mocha."
        elif ! grep -q '"workbench.colorTheme"' "$SETTINGS_JSON"; then
            # Insere a chave logo após a primeira chave '{'
            sed -i '0,/{/s//{\n    "workbench.colorTheme": "Catppuccin Mocha",/' "$SETTINGS_JSON"
            log "    Chave workbench.colorTheme adicionada ao settings.json existente."
        else
            log "    settings.json já tem workbench.colorTheme, nada a fazer."
        fi
    fi
else
    warn "VSCodium/VS Code não encontrado no PATH. Pulando instalação de temas."
    warn "Instale o editor primeiro e rode o script novamente, ou instale os temas manualmente."
fi

echo
log "Instalação concluída!"
echo "  Backup das configs antigas: $BACKUP_DIR"
echo "  Confira manualmente:"
echo "    - $ENV_LUA       (variáveis AMD)"
echo "    - $MONITORS_LUA  (monitor $MONITOR_NAME @ $MONITOR_MODE)"
if [ -n "$EDITOR_BIN" ]; then
    echo "    - Temas 'Emerald' (Ravenwood Dark) e 'E-ink' (baseline) não foram instalados"
    echo "      automaticamente — não consegui confirmar o extension ID correto. Busque"
    echo "      manualmente no Marketplace dentro do $EDITOR_BIN se quiser usá-los."
fi
