# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

from sphinx_pyproject import SphinxConfig

config = SphinxConfig(pyproject_file="../../pyproject.toml", style="poetry")

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = config.name
copyright = f"2024, {config.author}"
author = config.author
release = config.version
version_parts = release.split(".")
version_parts[-1] = "X"
version = ".".join(version_parts)

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = ["sphinx.ext.autodoc", "sphinx.ext.autosummary"]

templates_path = ["_templates"]
exclude_patterns = []

default_role = "py:obj"

smartquotes = False

maximum_signature_line_length = 88  # Matches the default for Black

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = "furo"
html_static_path = ["_static"]

# -- Options for autosummary -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/extensions/autosummary.html#generating-stub-pages-automatically

autosummary_ignore_module_all = False
