class Um < Formula
  desc "Command-line utility for creating and maintaining personal man pages"
  homepage "https://github.com/sinclairtarget/um"
  url "https://github.com/sinclairtarget/um/archive/refs/tags/4.2.0.tar.gz"
  sha256 "f8c3f4bc5933cb4ab9643dcef7b01b8e8edf2dcbcd8062ef3ef214d1673ae64e"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a1fe07dc6291ab69c1c4e7e6545be26dde8bfbf587f732860689535a7dad145f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "46ec29ef67ab6cbf8cde6a9d5029f6224f2fcc77a58f40f5feb178cacab94822"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b91d98a8fd437a600f933a582128c859b9cbf5f84ffd499275156db31c44f1b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e762de5b91a07098e4c24148a58d32e431ce4bbddce1980665137a60b1c5ca7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e762de5b91a07098e4c24148a58d32e431ce4bbddce1980665137a60b1c5ca7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8adee04ef491baecd2fb172ce7382a8082ba320b39f0d37ebe569a587ef145c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b91d98a8fd437a600f933a582128c859b9cbf5f84ffd499275156db31c44f1b5"
    sha256 cellar: :any_skip_relocation, ventura:        "0e762de5b91a07098e4c24148a58d32e431ce4bbddce1980665137a60b1c5ca7"
    sha256 cellar: :any_skip_relocation, monterey:       "0e762de5b91a07098e4c24148a58d32e431ce4bbddce1980665137a60b1c5ca7"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdec90ed59042a6701044f4bbc22e6b355426f9ba711f400899b672c1300d487"
    sha256 cellar: :any_skip_relocation, catalina:       "266b397cd3e24060e7926f438279325aed89643070618add3db64175e348c04b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "85c354a3514a26d514680306f030dfaa2a247f71ef772d1b3e1d5920b9c7fec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c71496a39f88373f2f233b19384bb1ef43e631b280ca0ba51ffcd2838012904f"
  end

  uses_from_macos "ruby"

  resource "kramdown" do
    url "https://rubygems.org/gems/kramdown-1.17.0.gem"
    sha256 "5862410a2c1692fde2fcc86d78d2265777c22bd101f11c76442f1698ab242cd8"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "um.gemspec"
    system "gem", "install", "--ignore-dependencies", "um-#{version}.gem"

    bin.install libexec/"bin/um"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    bash_completion.install "um-completion.sh"
    man1.install Dir["doc/man1/*"]
  end

  test do
    system bin/"um", "topic", "-d" # Set default topic

    output = shell_output("#{bin}/um topic")
    assert_match shell_output("#{bin}/um config default_topic"), output
  end
end
