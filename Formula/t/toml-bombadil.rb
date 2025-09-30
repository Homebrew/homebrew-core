class TomlBombadil < Formula
  desc "Dotfile manager with templating"
  homepage "https://github.com/oknozor/toml-bombadil"
  url "https://github.com/oknozor/toml-bombadil/archive/refs/tags/4.2.0.tar.gz"
  sha256 "b911678642a1229908dfeabbdd7f799354346c0e37f3ac999277655e01b6f229"
  license "MIT"
  head "https://github.com/oknozor/toml-bombadil.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2d56dd5101d3de48bc6ec47ede5a788021cd815ddaa0f3a9f39fd26f23b35ac4"
    sha256 cellar: :any,                 arm64_sequoia: "905ddd0270646b44ff488fb84dfb605629359c4d3621f6ad4539b8965116dbef"
    sha256 cellar: :any,                 arm64_sonoma:  "ce0dcbfe365b603d63838d1a13159dafe420206f4195c40cd9c2f6664a366760"
    sha256 cellar: :any,                 arm64_ventura: "5a7c807337580c8c0938e10b17baca04e0cca1730d3575a1de0ebe562c3732fe"
    sha256 cellar: :any,                 sonoma:        "a74977ffa395f041b92f6ef4e989d3cd8319cb1884bf82975b2bb889b30fe23e"
    sha256 cellar: :any,                 ventura:       "9f03631a0c28507a788635f902f3387bfbbf7a8c533e834b78c680b685dc7e54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b86e0ee0f27cb207b98bad86ef088454bb5950f3f5d18d751d24c8ef18adae8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2085ccd09aaa6ea756deb9d198231ffa1d83777c329f081ef3a1c62300ae1b4c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"bombadil", "generate-completions")
  end

  test do
    config_dir = if OS.mac?
      testpath/"Library/Application Support"
    else
      testpath/".config"
    end

    config_dir.mkpath
    (config_dir/"bombadil.toml").write <<~TOML
      dotfiles_dir = "dotfiles"
    TOML

    (testpath/"dotfiles").mkpath

    ENV["HOME"] = testpath

    output = shell_output("#{bin}/bombadil get vars")

    assert_match(/"arch":\s*".+"/, output)
    assert_match(/"os":\s*".+"/, output)
  end
end
