generate
========

This tool p rovide way for generate "anything" from templates.
Templates repository: [https://github.com/DmitryBochkarev/.templates](https://github.com/DmitryBochkarev/.templates)
By default templates looking in `~/.templates` but you can define `TEMPLATE_DIR` enviropment variable.

usage
=====

`$ generate generator output_dir template_name [template_options]`

exaples
=======

`$ generate batmanjs ./public/js controller --app=Hello --controller=World`
    Create file:
    /tmp/world_controller.coffee

`cat /tmp/world_controller.coffee`
    class Hello.WorldController extends Batman.Controller

license
=======

MIT/X11
