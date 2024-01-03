class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://github.com/jdx/rtx/archive/refs/tags/v2024.1.0.tar.gz"
  sha256 "0b78bb36f4bf566d0c2f11d1d31d4cf452b8fd73e04da3d0e6b407f66ee96697"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "758512a6037567e9cedbee4928c72f4661ff2d3eb59bed6b2840ce6762841849"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa9d990b1fde47ea0c76c03afcdda5abb1503c37e581c8f0c1f0e391eb28b782"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74b5a5c62a67fc7b0101e950d6e6c1209867d768399e7e168a8d83c36b8de3ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2f93901121072ae679ae74b572a6312a5822766b5bb8fdb04eb1f6b99005fd5"
    sha256 cellar: :any_skip_relocation, ventura:        "fcba3f4822d11389e1946dbbd1f06b9f7c3321558a197989a703316f1c9b8eb3"
    sha256 cellar: :any_skip_relocation, monterey:       "7fdb4b4016f154cfda86ee4729a01a77f279a671067db72f6ea4013a6cb1240e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e92dbf5aff4284a36acc0863ce8d168cdd5adc4fed89328fa4847bd9916a366b"
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
