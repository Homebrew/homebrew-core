class Tdom < Formula
  desc "XML/DOM/XPath/XSLT/HTML/JSON implementation for Tcl"
  homepage "https://tdom.org/"
  url "https://tdom.org/downloads/tdom-0.9.5-src.tgz"
  sha256 "ce22e3f42da9f89718688bf413b82fbf079b40252ba4dd7f2a0e752232bb67e8"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f98f56e8f8be62637a79a2a50e0e25c4560336a00d0aa3b33350f2b8021d9337"
    sha256 cellar: :any,                 arm64_sonoma:  "05e1ab5a96379f4cf427299ef7fc13cc7295201d099ebd729b4caca07ea29147"
    sha256 cellar: :any,                 arm64_ventura: "14999e9dad6567460b4947213240636d8d6a392b9e8dad78b015ec319ba8a228"
    sha256 cellar: :any,                 sonoma:        "3195c542314a9f7264cfd1d74ab76b81d984a0d64662ee9c8ae78678939be048"
    sha256 cellar: :any,                 ventura:       "306b99b603977df988833a0510efa21466efb0adb65172112ae93336d8a686f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc0da95e2734d23da915d3c5e7a1ca8a334a90142a3293307b5418b8533c07e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d70020be1396f84fdbfd00d80ba80ce290a0040b0e929ff7b8444d1f18c8882e"
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
