(defun m:odoo-template-tree()
  (interactive)
  (insert
   (concat
    "<!-- el campo id lo usas para referenciar esta vista -->\n"
    "        <record model=\"ir.ui.view\" id=\"...\">\n"
    "            <!-- el campo name es el string que aparece como -->\n"
    "            <!-- titulo de la vista cuando se abre -->\n"
    "            <field name=\"name\">...</field>\n"
    "            <!-- el campo model tiene que coincidir con la variable _name del model -->\n"
    "            <field name=\"model\">...</field>\n"
    "            <!-- dentro de arch va el cuerpo de la vista -->\n"
    "            <field name=\"arch\" type=\"xml\">\n"
    "                <tree string=\"...\">\n"
    "                    <field name=\"...\"/>\n"
    "                    <field name=\"...\"/>\n"
    "                    <field name=\"...\"/>\n"
    "                </tree>\n"
    "            </field>\n"
    "        </record>\n"
    )))

(defun m:odoo-template-form()
  (interactive)
  (insert
   (concat
    "<!-- el campo id lo usas para referenciar esta vista -->\n"
    "        <record model=\"ir.ui.view\" id=\"...\">\n"
    "            <!-- el campo name es el string que aparece como -->\n"
    "            <!-- titulo de la vista cuando se abre -->\n"
    "            <field name=\"name\">...</field>\n"
    "            <!-- el campo model tiene que coincidir con la variable _name del model -->\n"
    "            <field name=\"model\">...</field>\n"
    "            <!-- dentro de arch va el cuerpo de la vista -->\n"
    "            <field name=\"arch\" type=\"xml\">\n"
    "                <form string=\"...\">\n"
    "                    <group>\n"
    "                        <group>\n"
    "                            <field name=\"...\"/>\n"
    "                        </group>\n"
    "                        <group>\n"
    "                            <field name=\"...\"/>\n"
    "                        </group>\n"
    "                    </group>\n"
    "                </form>\n"
    "            </field>\n"
    "        </record>\n"
    )))

(defun m:odoo-template-action()
  (interactive)
  (insert
   (concat
    "<!-- el campo id de esta accion se usa en la propiedad action del menu -->\n"
    "        <record model=\"ir.actions.act_window\" id=\"act_afip_activity\">\n"
    "            <field name=\"name\">...</field>\n"
    "            <field name=\"res_model\">...</field>\n"
    "            <field name=\"type\">ir.actions.act_window</field>\n"
    "            <field name=\"view_type\">form</field>\n"
    "            <field name=\"view_mode\">tree,form</field>\n"
    "        </record>\n"
    )))

(global-set-key (kbd "C-x t") 'm:odoo-template-tree)
(global-set-key (kbd "C-x r") 'm:odoo-template-form)
(global-set-key (kbd "C-x e") 'm:odoo-template-action)

(provide 'mromay-odoo-templates)
