class Tracebox < Formula
  desc "Middlebox detection tool"
  homepage "https://github.com/tracebox/tracebox"
  url "https://github.com/tracebox/tracebox.git",
      tag:      "v0.4.4",
      revision: "4fc12b2e330e52d340ecd64b3a33dbc34c160390"
  license all_of: [
    "GPL-2.0-only",
    "BSD-3-Clause", # noinst/libcrafter
  ]
  revision 3
  head "https://github.com/tracebox/tracebox.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "45f15d0a644fc4eef18fac8f124fb9e4283c27e89e97ec98ae93d79ed4b4e8af"
    sha256 cellar: :any,                 arm64_sequoia:  "4477778df4c958271cb1d399c2a61efd383a466ef5ebf73d0710dd9d7ff55eeb"
    sha256 cellar: :any,                 arm64_sonoma:   "2932a710d67503cee019ef902088ab3f5000017f737dfa3818fd76db9d39d048"
    sha256 cellar: :any,                 arm64_ventura:  "9705e61653def47f938f0ec3f16fb21080f295a511a49c293e2c852574e656b3"
    sha256 cellar: :any,                 arm64_monterey: "b64f5f9a5ddb03779fd042bc15a95940e618c4de3fe7e2fcb9b5ad8959fab0f0"
    sha256 cellar: :any,                 sonoma:         "6abeaa63adac2a5329f9e40368963e975ba14f5cc86ce98fb28371c1299c7e37"
    sha256 cellar: :any,                 ventura:        "64fbec3f29837959980185a6df8c454f1fbfcc9eeff0f337acb80076b740482a"
    sha256 cellar: :any,                 monterey:       "8de9a06925cc930fd05d09f08924e323080d0cf375e5153781ffb4ba0071cce7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "22b4b1b26e23a933ca5145017f4c0ebc42846780d15063770cddb8626c5ad5cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "534c62a00f80541550000853b7656fba20be0e72dc879df166f7172b93460321"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "json-c"
  depends_on "lua"

  uses_from_macos "libpcap"

  def install
    unless OS.mac?
      ENV.cxx11 # work around error: reference to 'byte' is ambiguous
      ENV.append_to_cflags "-I#{Formula["libpcap"].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula["libpcap"].opt_lib}"
    end
    # Work around limited `libpcap` and `lua` search paths in configure.ac
    ENV.append "LIBS", "-lpcap -lm"
    ENV["LUA_INCLUDE"] = "-I#{Formula["lua"].opt_include}/lua"
    ENV["LUA_LIB"] = "-L#{Formula["lua"].opt_lib} -llua"

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--with-libpcap=yes",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Tracebox requires superuser privileges e.g. run with sudo.

      You should be certain that you trust any software you are executing with
      elevated privileges.
    EOS
  end

  test do
    system bin/"tracebox", "-v"
  end
end
