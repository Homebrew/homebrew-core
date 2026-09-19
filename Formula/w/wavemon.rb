class Wavemon < Formula
  desc "Ncurses-based monitoring application for wireless network devices on Linux"
  homepage "https://github.com/uoaerg/wavemon"
  url "https://github.com/uoaerg/wavemon/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "768d7c580fcc592efcacac924dcfd2ebe131608f5c8ac67d36e35731e1ac683a"
  license all_of: ["GPL-3.0-or-later", "ISC"]

  depends_on "autoconf" => :build
  depends_on "pkgconf" => :build
  depends_on "libnl"
  depends_on :linux
  depends_on "ncurses"

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install-suid-root"
  end

  def caveats
    <<~EOS
  wavemon can  optionally be run as root to enable its scanning functions.
  Either run:
      pkexec wavemon
  or:
      sudo $(brew --prefix wavemon)/bin/wavemon
    EOS
  end

  test do
    # This should work, it works outside Homebrew. Somehow it doesn't...

    # An exception occurred within a child process:
    # Minitest::Assertion: Expected: 1
    # Actual: nil
    # .../ruby/4.0.0/gems/minitest-6.0.6/lib/minitest/assertions.rb:176:in 'Minitest::Assertions#assert'
    # .../ruby/4.0.0/gems/minitest-6.0.6/lib/minitest/assertions.rb:211:in 'Minitest::Assertions#assert_equal'
    # .../formula_assertions.rb:40:in 'Homebrew::Assertions#shell_output'

    # assert_match "testwlan is not a usable wireless interface", shell_output("#{bin}/wavemon -i testwlan 2>&1", 1)
    assert_match "option requires an argument", shell_output("#{bin}/wavemon -i 2>&1", 1)
  end
end
