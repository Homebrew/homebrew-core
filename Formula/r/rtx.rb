class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://github.com/jdx/rtx/archive/refs/tags/v2023.12.40.tar.gz"
  sha256 "e4d3c78091113e49508b53c0cf782e788a89fbc18262ed1adf1550c2e1b1b818"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e2eed6bdaad80d5f0d52ff38e21712cd628820ab07d293646f462a673dda6c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f37f188f70bc4dcdc29dad050d74aca7a0d1620e5c8bf1eeab549ed109e5026"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00fb8ba1aac94bcd27c713e1642f3bcabb491bbd6d16e26ad6f36f539ceb5971"
    sha256 cellar: :any_skip_relocation, sonoma:         "026f6c98e747271be74b7dad483bf2cfb78d7147fbeb3a69004c9c89251c011d"
    sha256 cellar: :any_skip_relocation, ventura:        "769acc2a4ab00430841bdb771d68207da178ed886168a9402abb1f3b1ccafcb1"
    sha256 cellar: :any_skip_relocation, monterey:       "407665c8c51995214f3b8ca7db7699155dfad2375fd8b0e13471808d97418943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b100171fc3c918137c08e5224fd7c552a40b065214269e255629545297e60890"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"rtx-activate.fish").write <<~EOS
      if [ "$RTX_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/rtx activate fish | source
      end
    EOS
  end

  def caveats
    <<~EOS
      If you are using fish shell, rtx will be activated for you automatically.
    EOS
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
