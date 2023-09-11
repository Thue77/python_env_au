param ($folderName)

try {
if (-not($folderName)) {
    throw 'No folder name is given. Please give a foldername'
}

Write-Host 'checking version of pyenv'
try {
    pyenv --version
}
catch {
    Write-Host 'INFO::Pyenv is not installed'
    Write-Host 'INFO::Installing pyenv for Windows'
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"; &"./install-pyenv-win.ps1"
}

$pythonVersion = "3.11.4"

Write-Host "INFO::Installing python $pythonVersion with pyenv"
pyenv install $pythonVersion
Write-Host "INFO::Activate python $pythonVersion with pyenv"
pyenv global $pythonVersion
Write-Host 'INFO::Update pip and create virtual environment'
mkdir $folderName
Copy-Item .\pyproject.toml $folderName
Set-Location $folderName
python -m venv .venv
.\.venv\Scripts\activate
python -m pip install --upgrade pip
Write-Host 'INFO::Install pip-tools'
pip install pip-tools
Write-Host 'INFO::Compile requirements.txt'
pip-compile --generate-hashes --output-file=requirements.txt --resolver=backtracking pyproject.toml
Write-Host 'INFO::Install dependencies from dev-requirements.txt'
pip-sync requirements.txt

}
catch {
    throw $_
}