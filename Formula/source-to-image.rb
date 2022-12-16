class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.3.2",
      revision: "78363eee76a5c52f23df3bbffb4e2e8393b4a043"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "837df64d313a095568862375ab3c995e7dbff0f733e8e3c629a2bcf0b7e468e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ea9c3737a8b610bb2312e4b5e89fa368752c97c03492b18d693f74893c1a7bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "061fb0dc940cea966ed7c7e120f9e6243f394ca3aa4f31f622114bf4fa1e3aca"
    sha256 cellar: :any_skip_relocation, ventura:        "8dd0d6b80788362ea7ddaa927c6916cccf1ff376a3969d25ec79c5a4f7412fe7"
    sha256 cellar: :any_skip_relocation, monterey:       "0856c38eed694da5621b1d521be8d760ab0b1af9e12f4b33092fe21cc6b4716c"
    sha256 cellar: :any_skip_relocation, big_sur:        "98ebaa1908167528ae02c2ae96c38b02e5918403c46171a4da0da99db1129879"
    sha256 cellar: :any_skip_relocation, catalina:       "fda0b4ffe09c6d6091636b2699c64b7df37fc002fa2819a44c165e0005b990ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f840fd861731a8d2f078f2da755a771e58e2f31712ade195ff10c29a4037deaa"
  end

  depends_on "go" => :build

  def install
    system "hack/build-go.sh"
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install "_output/local/bin/#{OS.kernel_name.downcase}/#{arch}/s2i"

    generate_completions_from_executable(bin/"s2i", "completion", shells: [:bash, :zsh], base_name: "s2i")
  end

  test do
    system "#{bin}/s2i", "create", "testimage", testpath
    assert_predicate testpath/"Dockerfile", :exist?, "s2i did not create the files."
  end
end
