# Declare custom installation commands
define custom_install_commands
        @echo "Installing extra config files from miltador/lede-image-boilerplate"
        $(INSTALL_DIR) $(1)../../../files/etc
endef

# Append custom commands to install recipe,
# and make sure to include a newline to avoid syntax error
Package/base-files/install += $(newline)$(custom_install_commands)
