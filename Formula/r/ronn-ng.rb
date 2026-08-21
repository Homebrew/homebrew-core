class RonnNg < Formula
  desc "Build man pages from Markdown"
  homepage "https://github.com/apjanke/ronn-ng"
  url "https://github.com/apjanke/ronn-ng/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "180f18015ce01be1d10c24e13414134363d56f9efb741fda460358bb67d96684"
  license "MIT"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "dde9c2f7f7a4408122bf2e436c38950b331b89fbf58033f700145e021e64ff48"
    sha256 cellar: :any, arm64_sequoia: "a3dd75ac390b8dad4a71bf0400e8d7bf9f3dfa7e25c562244b7baaef3e778c7b"
    sha256 cellar: :any, arm64_sonoma:  "c3999ca5ca78a084f011f5f7b5863d2ece2e5bd0d72eac6e47597430c7745151"
    sha256 cellar: :any, sonoma:        "75fb55360eecf063982b42adbb342e023ea97cb29bc2f86f8b01d1bf524a53bc"
    sha256 cellar: :any, arm64_linux:   "2f0612ea0a0f30b42d2ecbc8f59320fe91961b46c92a1deecb557bf264481cdb"
    sha256 cellar: :any, x86_64_linux:  "84de592651e7b58252e8be9069b46c2369731987a872db0810804a0c129d7461"
  end

  depends_on "ruby"
  depends_on "xz"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zlib-ng-compat"
  end

  conflicts_with "ronn", because: "both install `ronn` binaries"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "config", "set", "build.nokogiri", "--use-system-libraries"
    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"

    bin.install libexec/"bin/ronn"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    bash_completion.install "completion/bash/ronn"
    zsh_completion.install "completion/zsh/_ronn"
    man1.install Dir["man/*.1"]
    man7.install Dir["man/*.7"]
  end

  test do
    (testpath/"test.ronn").write <<~MARKDOWN
      helloworld
      ==========

      Hello, world!
    MARKDOWN

    assert_match "Hello, world", shell_output("#{bin}/ronn --roff --pipe test.ronn")
  end
end
