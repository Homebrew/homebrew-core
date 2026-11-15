class Tcltls < Formula
  desc "OpenSSL extension to Tcl"
  homepage "https://core.tcl-lang.org/tcltls/home"
  url "https://core.tcl-lang.org/tcltls/uv/tcltls2.0.1.tar.gz"
  sha256 "afffeb5de1978f47745db4804c1dfdcd6605ceac32e324fe8bbe49843de0baae"
  license "TCL"

  livecheck do
    url "https://core.tcl-lang.org/tcltls/wiki/Download"
    regex(/href=.*?tcltls[._-]?v?(\d+(?:\.\d+)+)(?:[._-]src)?\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cba54878d7156ebfe2226fc1e7272a3a3687e44f4c05fba779fd5ba827377b3c"
    sha256 cellar: :any, arm64_tahoe:       "242a551b11f27d1b0d6e880ac71d4e8b75095ad4a154244aec4ee2b1f1b0a71d"
    sha256 cellar: :any, arm64_sequoia:     "89d1a7abd5f143bd10e8bb0e95b1ecf0448c12d7dc39d85df4da971a6265bd4a"
    sha256 cellar: :any, arm64_linux:       "8c755242aa20cd516972978a4154ed0174bb913d38a462be40d00a50f8705bf1"
    sha256 cellar: :any, x86_64_linux:      "3dadfa59d23d3ca9ede06eead4d0d35a417da14e1013c81fcc697e50e61862b7"
  end

  depends_on "openssl@4"
  depends_on "tcl-tk" => :no_linkage

  link_overwrite "include/tcl-tk/tls.h", "share/man/mann/tls.n.gz"

  allow_network_access! :test

  def install
    system "./configure", "--includedir=#{include}/tcl-tk",
                          "--with-openssl-dir=#{formula_opt_prefix("openssl@4")}",
                          "--with-tcl=#{formula_opt_lib("tcl-tk")}",
                          "--with-tclinclude=#{formula_opt_include("tcl-tk")}/tcl-tk",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.tcl").write <<~TCL
      package require tls

      set host "brew.sh"
      set port 443
      set path "/"
      set proto "http/1.1"

      set ch [::tls::socket -servername $host -request 1 -require 1 -alpn [list [string tolower $proto]] $host $port]
      chan configure $ch -blocking 1 -buffering line -buffersize 16384 -encoding utf-8 -translation {auto crlf}

      ::tls::handshake $ch
      after 1000

      puts $ch [format "GET %s %s" $path [string toupper $proto]]
      puts $ch [format "User-Agent: Mozilla/4.0 (compatible; %s)" $::tcl_platform(os)]
      puts $ch [format "Host: %s" $host]
      puts $ch [format "Connection: close"]
      puts $ch ""
      flush $ch
      after 1000

      while {1} {
        set line [gets $ch]
        if {!([string length $line] == 0 && [eof $ch])} {
          puts $line
        } elseif {[eof $ch]} {
          close $ch
          break
        }
      }
    TCL
    assert_match "The Package Manager for Everywhere", shell_output("#{formula_opt_bin("tcl-tk")}/tclsh test.tcl")
  end
end
