class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta/archive/v1.1.1.tar.gz"
  sha256 "f2289274538124984bebb09b0968c2821368d8a80d60b9615e4f999f6751366d"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/volta-cli/volta.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91f86479b539d9df009da79e569b1ab740f7e5ed635f537a639f7f65c446f69e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8454fe11303c2d14a4e77b9dadc086bb12fa94aa71fdbec50f4e03a49d5e473"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b16b992a717720120aa9826992f4b217722b1153254a05b68afaa5f02fc8bb9d"
    sha256 cellar: :any_skip_relocation, ventura:        "ed384b28700d57dabca74fc9a34e25840e0e241b2dca4fb8a7d6261eff0a797b"
    sha256 cellar: :any_skip_relocation, monterey:       "edb4737847ade262f0f2812e599ae6e900d4a1c1d12e323307c70c971cf023ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "e56c356f2c0c914da2d98d62de1b52d118e6108eadad86fa5d8c75ec1cf64e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0405ae0886b099de89c2b242d70c3cc2cd4f206ce5a0478fbe2635e37b16684"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"volta", "completions")

    bin.each_child do |f|
      basename = f.basename
      next if basename.to_s == "volta-shim"

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, VOLTA_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    system bin/"volta", "install", "node@19.0.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")
    path = testpath/"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}/.volta/bin/node #{path}").strip
    assert_equal "hello", output
  end
end
