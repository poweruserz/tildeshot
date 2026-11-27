# Maintaining the documentation

The narrative documentation is written in markdown and built into HTML using
[MkDocs][mkdocs], particularly the [MkDocs material theme][mkdocs-material]. The
source code documentation is generated using Doxygen and adapted for MkDocs
using [MkDoxy][mkdoxy] (a tweaked custom fork of the original). The source code
of this documentation can be found [here][doc-source].

!!! tip

    In order to edit a page from the documentation, click the :material-pencil:
    button in the top right corner of the page. Please note that this button
    won't work within the API section of the documentation - the button is
    removed from there during [post-processing][], but it will still be visible
    when [serving the website locally][serving-locally].

## Serving locally
To serve the documentation locally, run the `make serve` target in the
`docs/dev` directory. The server is available at the port designated in the
output of the command.

## Notes and conventions
- When you add new files or rename existing files or section names, be sure to
  edit the `nav` property of [mkdocs.yml][mkdocs.yml].
- Always insert links as [reference style
  links][markdown:reference-style-links]. This will make the docs source code
  more readable and make broken links more easily detectable and replaceable.

### Post-processing
There are some tweaks we make to the generated HTML documentation. We do that in
the `make build` target, by running the [post-process.sh][post-process.sh]
script. To see what post-processing we do, see that file.

For this reason, the version of the documentation served locally using `make
serve` will not match the generated HTML documentation 100%. But those
inconsistencies are few and minor.

## Dependencies
```shell
pip install \
    mkdocs==1.6.1 \
    mkdocs-material==9.7.7 \
    git+https://github.com/veracioux/mkdoxy@v1.0.0
```

Use doxygen 1.9.1 (Ubuntu 22.04); doxygen 1.9.4 makes mkdoxy 1.0.0 crash.

!!! note

    We use a forked version of [mkdoxy][mkdoxy-original] that can be found
    [here][mkdoxy], that fixes some annoying things from the original.

## Deployment

The developer documentation is served with GitHub Pages at
[poweruserz.github.io/tildeshot][website].

The [deploy-dev-docs][] workflow runs on every push to `master` that touches
`src/`, `docs/dev/` or the workflow itself. It builds the docs, uploads
`docs/dev/output` as a Pages artifact and deploys it. No branch or access token
is involved; the workflow uses the repository's own Pages permissions.

GitHub Pages must be enabled in the repository settings with **GitHub Actions**
as the source.

<!-- Internal links -->
[post-processing]: #post-processing
[serving-locally]: #serving-locally

<!-- Tildeshot-related pages -->
[website]: https://poweruserz.github.io/tildeshot/
[doc-source]: https://github.com/poweruserz/tildeshot/tree/master/docs/dev

<!-- Files in tildeshot repo -->
[mkdocs.yml]: https://github.com/poweruserz/tildeshot/blob/master/docs/dev/mkdocs.yml
[post-process.sh]: https://github.com/poweruserz/tildeshot/blob/master/docs/dev/post-process.sh
[deploy-dev-docs]: https://github.com/poweruserz/tildeshot/blob/master/.github/workflows/deploy-dev-docs.yml

<!-- External pages -->
[markdown:reference-style-links]: https://www.markdownguide.org/basic-syntax/#reference-style-links
[mkdocs]: https://www.mkdocs.org/
[mkdocs-material]: https://squidfunk.github.io/mkdocs-material
[mkdoxy-original]: https://github.com/JakubAndrysek/mkdoxy
[mkdoxy]: https://github.com/veracioux/mkdoxy
