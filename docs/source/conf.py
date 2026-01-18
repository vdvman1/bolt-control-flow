# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

from sphinx_pyproject import SphinxConfig

config = SphinxConfig(pyproject_file="../../pyproject.toml")

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = config.name
copyright = f"2026, {config.author}"
author = config.author
release = config.version
version_parts = release.split(".")
version_parts[-1] = "X"
version = ".".join(version_parts)

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    "sphinx.ext.napoleon",
    "autoapi.extension",
]

templates_path = ["_templates"]
exclude_patterns = []

default_role = "py:obj"

rst_prolog = """
.. role:: python(code)
   :language: python
"""

smartquotes = False

maximum_signature_line_length = 88  # Matches the default for Black

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = "furo"
html_static_path = ["_static"]

# -- Options for autoapi -----------------------------------------------------
# https://sphinx-autoapi.readthedocs.io/en/latest/reference/config.html

autoapi_dirs = ["../../bolt_control_flow"]
autoapi_options = [
    "members",
    "inherited_members",
    "undoc-members",
    "special_members",
    "show-inheritance",
    "show-module-summary",
    "imported-members",
]
