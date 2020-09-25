class Act < Formula
  desc "Run your GitHub Actions locally 🚀"
  homepage "https://github.com/nektos/act"
  url "https://github.com/nektos/act/archive/v0.2.14.tar.gz"
  sha256 "bd18b6ba580d96fb6bd72ef34ebd12f947aadd1de7f4b3d07e363a8bea380dbc"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "45b97caf0a32d9fd2c30ee80642131fda3eef9a9337075ffee6bfd1c85d6b199" => :catalina
    sha256 "d5b7d405dbd800c5fe601fb099898c5c3cbecb9e8b5d11ea5f6ff997550d4791" => :mojave
    sha256 "145f66b76a32982605c607aa2ec1d3ff53fb40c12d30ef700f2b67a19691bf86" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "dist/local/act"
  end

  test do
    system "git", "clone", "https://github.com/stefanzweifel/laravel-github-actions-demo.git"
    cd "laravel-github-actions-demo" do
      system "git", "checkout", "v2.0"

      pull_request_jobs = shell_output("#{bin}/act pull_request --list")
      assert_match "php-cs-fixer", pull_request_jobs

      push_jobs = shell_output("#{bin}/act push --list")
      assert_match "phpinsights", push_jobs
      assert_match "phpunit", push_jobs
    en
  en
en
{{...>>>>>$ touch ~/.ssh/config$<<<<<}}


[          
                                 ...$ eval "$(ssh-agent -s)"
> Agent pid 59566







MWM@@@@!?
////]]™
