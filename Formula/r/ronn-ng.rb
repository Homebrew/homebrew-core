class RonnNg < Formula
  desc "Build man pages from Markdown"
  homepage "https://github.com/apjanke/ronn-ng"
  url "https://github.com/apjanke/ronn-ng/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "180f18015ce01be1d10c24e13414134363d56f9efb741fda460358bb67d96684"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3a36bd1699825e23e988f88430a33992b0d1cb846897e93b7e55d4f48c1c6d0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f31d048c5ebca214ad11c695656894dc560ca865000a78e659985289abcd31ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bee63a22338f66fedbcca8ba2c67035ef78024d8b44462819737c37ff2f62cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1c684641c1b5361e3100e634364d39823eaa4067c7ce2b99993c15c7a9f952f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8d059eec73a18c2e2a887d0158c6be288be08be86038e9cbe65d437a68e89d7"
    sha256 cellar: :any_skip_relocation, ventura:        "bc2e51f2b46864a3997b53c9652d68732639b3d9fa70d59ad872b97b1faf073b"
    sha256 cellar: :any_skip_relocation, monterey:       "edb291c1f1fd2744613fb4e6ebe61ced523410143b2fc385845a850a29d79935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad7f030d0d67dcf77826a7362288d99b334d783a255fd7670d20cbbe417d4148"
  end

  # Nokogiri 1.9 requires a newer Ruby
  depends_on "ruby"

  conflicts_with "ronn", because: "both install `ronn` binaries"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "ronn-ng.gemspec"
    system "gem", "install", "ronn-ng-#{version}.gem"
    bin.install libexec/"bin/ronn"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    bash_completion.install "completion/bash/ronn"
    zsh_completion.install "completion/zsh/_ronn"
    man1.install Dir["man/*.1"]
    man7.install Dir["man/*.7"]
  end

  test do
    (testpath/"test.ronn").write <<~EOS
      helloworld
      ==========

      Hello, world!
    EOS

    assert_match "Hello, world", shell_output("#{bin}/ronn --roff --pipe test.ronn")
  end
end
