import os
import pytest
import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')

#-----Checking if the package is installed-------
@pytest.mark.parametrize('pkg', [
'httpd'
])
def test_pkg(host, pkg):
    package = host.package(pkg)
    assert package.is_installed

#------Checking that file exists and contains the content-------
@pytest.mark.parametrize('file, content', [
("/var/www/html/index.html", "Example page")
])
def test_files(host, file, content):
    file = host.file(file)
    assert file.exists
    assert file.contains(content)
