class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta/archive/v1.1.1.tar.gz"
  sha256 "f2289274538124984bebb09b0968c2821368d8a80d60b9615e4f999f6751366d"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/volta-cli/volta.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cde68354207972b898b25e7dc58912a05f8983f59584ff83264c78585b62d9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f882146e42fbe42114d0b83f3ebd4c8a6f2e3067c34fcd57ef5cbc2479bfe4cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0fa74388ad8acdbd8e45797cc4d0c95768961f5572edb615e4d201e1856b42f"
    sha256 cellar: :any_skip_relocation, ventura:        "22c04b49c0c85be41384d10bf5b758c98cfa4f553c609e7c709cebb1928abbb4"
    sha256 cellar: :any_skip_relocation, monterey:       "83c2b2bac0918e67881bfbc9e0c94559cd8ef4044cd1c2c67dd6ed7009577c42"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6e45238363b0aa39ef5b4d38faa69d77d772a7e82aca39999c05c472334aaea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4253bedc1215189b5d5a658c619a2c647ee65588a9a4d288ffe9d70a380f99e"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"volta", "completions")

    libexec.install bin
    (libexec/"bin").each_child do |f|
      basename = f.basename
      (bin/basename).write_env_script f, VOLTA_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    system bin/"volta", "install", "node@19.0.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")
  end
end
