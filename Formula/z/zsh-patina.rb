class ZshPatina < Formula
  desc "Blazingly fast Zsh syntax highlighter"
  homepage "https://github.com/michel-kraemer/zsh-patina"
  url "https://github.com/michel-kraemer/zsh-patina/archive/refs/tags/1.10.0.tar.gz"
  sha256 "045f219f9d73b8fd57fef619be307129b8b5b740d969a0c61fdbc709673a606e"
  license "MIT"
  head "https://github.com/michel-kraemer/zsh-patina.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc191ca58cdc0311a63c06e39648731bf8d80262d71129d26e2aee9e52bd40ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24d05678e28fd76d2144c4fa9cd745d2a96d607ff8cb2886bc406055b824b602"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "940514999af87c27e5a43431e2484da3fa35844a5cce5c3377e84e5306f92515"
    sha256 cellar: :any_skip_relocation, sonoma:        "c41650b0d74b73562e0b0d7199f6d601f32b37e8c0bba92c284f289a74a7255c"
    sha256 cellar: :any,                 arm64_linux:   "0a29df30fa0480bef0d35a45ca054436e0a873870705cef4f4dc639a8096b19a"
    sha256 cellar: :any,                 x86_64_linux:  "c70a3dea00ffed9ce2d6657e4596b3d3d62696bb708a33ce2cbe02b8bd5ed8d3"
  end

  depends_on "rust" => :build

  uses_from_macos "zsh" => :test

  def install
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "fat"
    ENV["CARGO_PROFILE_RELEASE_CODEGEN_UNITS"] = "1"

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"zsh-patina", "completion",
      shell_parameter_format: :none, shells: [:zsh])
  end

  def caveats
    <<~EOS
      Initialize zsh-patina at the end of your `.zshrc` file by executing:
        echo 'eval "$(#{opt_bin}/zsh-patina activate)"' >> ~/.zshrc
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zsh-patina --version")

    output = shell_output("zsh -c 'eval \"$(#{bin}/zsh-patina activate)\" && type -w zsh-patina'")
    assert_match "zsh-patina: function", output
  end
end
