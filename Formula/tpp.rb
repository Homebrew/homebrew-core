class Tpp < Formula
  desc "Ncurses-based presentation tool"
  homepage "https://synflood.at/tpp.html"
  url "https://synflood.at/tpp/tpp-1.3.1.tar.gz"
  sha256 "68e3de94fbfb62bd91a6d635581bcf8671a306fffe615d00294d388ad91e1b5f"

  livecheck do
    url :homepage
    regex(/href=.*?tpp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina:    "e2875a7547a670ff0b23af7c9c96db096c365d4ac57f4ec706d1d9453cef9076"
    sha256 cellar: :any_skip_relocation, mojave:      "bd92be45cec9c61438618155e9d22fe58c03b0feedbd8272a214d20edf37f16a"
    sha256 cellar: :any_skip_relocation, high_sierra: "e132735b420b285a5ffd5f6946d93a2e67f8797e07f00d2bce40f8c7989ff65a"
    sha256 cellar: :any_skip_relocation, sierra:      "8736306dac4a3d2a2ed8bb4dcd1c08c77fb9026b9cde5ad07791eb90eef2392f"
    sha256 cellar: :any_skip_relocation, el_capitan:  "25e92e9f229433131cc82cf48a3cec90d19a28a08a56fadcc095b1ecf4df2304"
  end

  resource "ncurses-ruby" do
    url "https://downloads.sourceforge.net/project/ncurses-ruby.berlios/ncurses-ruby-1.3.1.tar.bz2"
    sha256 "dca8ce452e989ce1399cb683184919850f2baf79e6af9d16a7eed6a9ab776ec5"
  end

  def install
    lib_ncurses = libexec+"ncurses-ruby"
    inreplace "tpp.rb", 'require "ncurses"', <<~EOS
      require File.expand_path('#{lib_ncurses}/ncurses_bin.bundle', __FILE__)
      require File.expand_path('#{lib_ncurses}/ncurses_sugar.rb', __FILE__)
    EOS

    bin.install "tpp.rb" => "tpp"
    share.install "contrib", "examples"
    man1.install "doc/tpp.1"
    doc.install "README", "CHANGES", "DESIGN", "COPYING", "THANKS", "README.de"

    resource("ncurses-ruby").stage do
      # Missing include leads to compilation failure with Xcode 9
      # Reported by email on 2018-03-13
      inreplace "ncurses_wrap.c", '#include "ncurses_wrap.h"',
                                  "#include \"ncurses_wrap.h\"\n#include <sys/time.h>"

      inreplace "extconf.rb", '$CFLAGS  += " -g"',
                              '$CFLAGS  += " -g -DNCURSES_OPAQUE=0"'
      system "ruby", "extconf.rb"
      system "make"
      lib_ncurses.install "lib/ncurses_sugar.rb", "ncurses_bin.bundle"
    end
  end

  test do
    assert_equal "tpp - text presentation program #{version}",
                 shell_output("#{bin}/tpp --version", 1).chomp
  end
end
