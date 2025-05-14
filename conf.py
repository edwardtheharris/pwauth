# pylint: disable=invalid-name,redefined-builtin
"""
Configuration file for the Sphinx documentation builder.

For the full list of built-in configuration values, see the documentation:
https://www.sphinx-doc.org/en/master/usage/configuration.html

-- Project information -----------------------------------------------------
https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

-- General configuration ---------------------------------------------------
https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration
"""
from pathlib import Path
import version_query


def get_release():
    """Set the relase of the current package."""
    try:
        cur_release = version_query.query_folder(Path("."))
    except ValueError:
        cur_release = version_query.Version(0, 0, 1)
    return cur_release.to_str()


author = "Xander Harris"
autoyaml_root = "."
copyright = "2024, Xander Harris"
exclude_patterns = [
    "_build",
    "Thumbs.db",
    ".DS_Store",
    ".pytest_cache/*",
    ".tox/*",
    ".venv/*",
]
extensions = [
    "myst_parser",
    "sphinx.ext.autodoc",
    "sphinx.ext.coverage",
    "sphinx.ext.duration",
    "sphinx.ext.githubpages",
    "sphinx.ext.graphviz",
    "sphinx.ext.todo",
    "sphinx_copybutton",
    "sphinx_design",
    "sphinx_git",
    "sphinx_last_updated_by_git",
    "sphinxcontrib.autoyaml",
]
git_untracked_check_dependencies = False
graphviz_output_format = "png"
# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output
html_context = {"full_path": str(Path(".").resolve())}
html_static_path = ["_static"]
html_theme = "sphinx_book_theme"
myst_enable_extensions = [
    "amsmath",
    "attrs_block",
    "attrs_inline",
    "colon_fence",
    "deflist",
    "dollarmath",
    "fieldlist",
    "html_admonition",
    "html_image",
    "linkify",
    "replacements",
    "smartquotes",
    "strikethrough",
    "substitution",
    "tasklist",
]
myst_footnote_transition = True
myst_title_to_header = True
project = "Xander's Dot Files and Sundry Store"
release = get_release()
show_authors = True
source_suffix = {
    ".md": "markdown",
}
templates_path = ["_templates"]
