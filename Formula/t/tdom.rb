class Tdom < Formula
  desc "XML/DOM/XPath/XSLT/HTML/JSON implementation for Tcl"
  homepage "https://tdom.org/"
  url "https://tdom.org/downloads/tdom-0.9.6-src.tgz"
  sha256 "6d24734aef46d1dc16f3476685414794d6a4e65f48079e1029374477104e8319"
  license "MPL-2.0"

  livecheck do
    url :homepage
    regex(/Version\s+(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7cfaef92f1e79bcce4c0e7ed3ba44b81b68d2a8b0f955d92fd6463f5c3e31cc0"
    sha256 cellar: :any,                 arm64_sequoia: "132444e6d526fd8ab26c5cedbd60ea6eb070689e8551eed98eec3e3dbbb75790"
    sha256 cellar: :any,                 arm64_sonoma:  "d553de086d764b486a032381561ff2b3618a902129e95450eff02b943dbba81d"
    sha256 cellar: :any,                 sonoma:        "7d15afef159e03e1ce529b513d6b8420990c831549b1f9a934442d15cf186183"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "503ed2c27b2f2720616851d1c91bb4e2ba1321ca0d3fc9b4031059387f406e73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "788c41cb463f200f82fa69ec0219b4b0694b671b556c60e2709fea7585c11a7f"
  end

  depends_on "tcl-tk"

  def install
    system "./configure", "--disable-silent-rules", "--with-tcl=#{ENV["HOMEBREW_PREFIX"]}/lib", *std_configure_args
    system "make", "install"
  end

  test do
    test_tdom = <<~TCL
      if {[catch {
        package require tdom

        set xml {<?xml version="1.0"?>
          <root>
            <child>12345</child>
          </root>}

        set doc [dom parse $xml]
        set node [$doc selectNodes root/child/text()]
        if {[$node data] == "12345"} {
          puts "OK"
        }
      } resultVar]} {
        puts $resultVar
      }
    TCL

    assert_equal "OK", pipe_output("#{ENV["HOMEBREW_PREFIX"]}/bin/tclsh", test_tdom).chomp
  end
end
