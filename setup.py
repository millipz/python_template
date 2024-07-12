from setuptools import setup, find_packages

# Read requirements from requirements.in
with open("requirements.in") as f:
    requirements = f.read().splitlines()

setup(
    name="template_project",
    version="0.1.0",
    description="Empty template project",
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    author="Miles Phillips",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    install_requires=requirements,
    entry_points={
        "console_scripts": [
            "template_package=template_package.main:main",
        ],
    },
)
