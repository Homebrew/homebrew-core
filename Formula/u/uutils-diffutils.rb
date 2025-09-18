class UutilsDiffutils < Formula
  desc "Cross-platform Rust rewrite of the GNU diffutils"
  homepage "https://uutils.github.io/diffutils/"
  url "https://github.com/uutils/diffutils/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "3be767b5417fb5358d6a979603628c9a926367c700c45335e888b605d9d16ef4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/uutils/diffutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1f477add026e8b2295da234cfc09ec20062d59156b7a96dcde891ed18fe9eb5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5b9c46a4be56b29642e8ea525e0e4f805fbb17285bb255359f20b373fb8ad189"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d016794b8782c3113ba872639c5969b51f49b58e2e39956ebdca05b62c5662cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acdb4a2f8fbe583ed632f18cac365ca767af2e86739dd636e77ad8bd912e0d1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bca2a21c5c80ada29af665c945506e8f592bdaac961bd6ed6fb5eb8a498e05d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6c35358ce672179dfcca353ac742008c4a674f40a6ac414f87250279ccbed1b"
    sha256 cellar: :any_skip_relocation, ventura:        "164477ab12dacdd32526a9fab350043799be6d63a0341995e86d1f170d112389"
    sha256 cellar: :any_skip_relocation, monterey:       "fc5c26ab72d931c1a0c4f6f6c40ccf9986d4ce96b43b5e9471444d2e4351b1d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cbffc8e98550a7bfbacb94a2294de960775adae4472b69e3c0f57c942098cf67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e18f180be6675b73db0198972f114cb11af7b36a5f8b99c005b5447d42c7415"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(root: libexec)
    mv libexec/"bin", libexec/"uubin"
    Dir.children(libexec/"uubin").each do |cmd|
      bin.install_symlink libexec/"uubin"/cmd => "u#{cmd}"
    end
  end

  def caveats
    <<~EOS
      All commands have been installed with the prefix "u".
      If you need to use these commands with their normal names, you
      can add a "uubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/uubin:$PATH"
    EOS
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system bin/"udiffutils", "a", "b"
  end
end
