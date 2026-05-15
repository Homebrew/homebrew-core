class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/6e/4f/0adc4aed40e8fb8ba167ad77ac0ab2b21205d31881817b16050412dae2ab/snakefmt-1.1.0.tar.gz"
  sha256 "72f7405c55447a072e5a8356bff0f712d8a37bbdddb79d0ed843ce9453a75d08"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c845043c4c1d836761739d24127e92b93e00a02fb8023f35fecbebf60fa49749"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9e83d5daf55b84c936718fc9dbf8bdeef3c7537355786b668ca09d18bc8281d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be966da9f84044fe6cb67c50a8a4b239ffc03eb43f2d0b8cff972d7258fd0b51"
    sha256 cellar: :any_skip_relocation, sonoma:        "a349079d63be74621c96f3c1f9db52de82b34dc6f237c89fe33fcf8945702892"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffc69b62223737020ecb4acb3c2bde8519f49e94ca1b40943b55085790ffb835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ea2401d251efbbfc23d177b85e3a24b1c18837064ef55b18f3cb1822e9b9adb"
  end

  depends_on "python@3.14"

  resource "black" do
    url "https://files.pythonhosted.org/packages/e1/c5/61175d618685d42b005847464b8fb4743a67b1b8fdb75e50e5a96c31a27a/black-26.3.1.tar.gz"
    sha256 "2c50f5063a9641c7eed7795014ba37b0f5fa227f3d408b968936e24bc0566b07"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/57/75/31212c6bf2503fdf920d87fee5d7a86a2e3bcf444984126f13d8e4016804/click-8.3.2.tar.gz"
    sha256 "14162b8b3b3550a7d479eafa77dfd3c38d9dc8951f6f69c78913a8f9a7540fd5"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/a2/6e/371856a3fb9d31ca8dac321cda606860fa4548858c0cc45d9d1d4ca2628b/mypy_extensions-1.1.0.tar.gz"
    sha256 "52e68efc3284861e772bbcd66823fde5ae21fd2fdb51c62a211403730b916558"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/de/0d2b39fb4af88a0258f3bac87dfcbb48e73fbdea4a2ed0e2213f9a4c2f9a/packaging-26.1.tar.gz"
    sha256 "f042152b681c4bfac5cae2742a55e103d27ab2ec0f3d88037136b6bfe7c9c5de"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/fa/36/e27608899f9b8d4dff0617b2d9ab17ca5608956ca44461ac14ac48b44015/pathspec-1.0.4.tar.gz"
    sha256 "0210e2ae8a21a9137c0d470578cb0e595af87edaa6ebf12ff176f14a02e0e645"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "pytokens" do
    url "https://files.pythonhosted.org/packages/b6/34/b4e015b99031667a7b960f888889c5bd34ef585c85e1cb56a594b92836ac/pytokens-0.4.1.tar.gz"
    sha256 "292052fe80923aae2260c073f822ceba21f3872ced9a68bb7953b348e561179a"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"snakefmt", shell_parameter_format: :click)
  end

  test do
    test_file = testpath/"Snakefile"
    test_file.write <<~EOS
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    test_output = shell_output("#{bin}/snakefmt --check #{test_file} 2>&1", 1)
    assert_match "[INFO] 1 file(s) would be changed 😬", test_output

    assert_match "snakefmt, version #{version}",
      shell_output("#{bin}/snakefmt --version")
  end
end
