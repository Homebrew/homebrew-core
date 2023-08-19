class Suricata < Formula
  desc "Network IDS, IPS, and security monitoring engine"
  homepage "https://suricata.io"
  url "https://www.openinfosecfoundation.org/download/suricata-7.0.0.tar.gz"
  sha256 "7bcd1313118366451465dc3f8385a3f6aadd084ffe44dd257dda8105863bb769"
  license "GPL-2.0-only"

  livecheck do
    url "https://suricata.io/download/"
    regex(/href=.*?suricata[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "d58069d6aabe6fdaf36f5f23bad35b48d9e288f61e4913e7591e8f4447706d46"
    sha256 arm64_monterey: "b23b1457fb6c4fdbf1383d2774c07d2d83ff15bb104397f0a8475c743d8ee4b7"
    sha256 arm64_big_sur:  "3c1987e4fee155ccb835a2a5e0ca0003a9d4f3591b0766735f844849999cc42b"
    sha256 ventura:        "d5603e316135025853b112f3200aecb3d78f5a8f4e2115b4edbfaf711e153e36"
    sha256 monterey:       "7c1e14f47f9456a263a37636a1a98c3a878e5f129163ebc7c7040563e1cceaeb"
    sha256 big_sur:        "cf3cc309c09683104ab7ee04c562861423305d8f36715ab62747be28b721dab4"
    sha256 x86_64_linux:   "1145649e95a1b9b22b2d180b77b3ef4850ab120394b1eb9c2957d553b0ebd3c6"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "jansson"
  depends_on "libmagic"
  depends_on "libnet"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "python@3.11"
  depends_on "pyyaml"

  uses_from_macos "libpcap"

  def install
    jansson = Formula["jansson"]
    libmagic = Formula["libmagic"]
    libnet = Formula["libnet"]

    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-libjansson-includes=#{jansson.opt_include}
      --with-libjansson-libraries=#{jansson.opt_lib}
      --with-libmagic-includes=#{libmagic.opt_include}
      --with-libmagic-libraries=#{libmagic.opt_lib}
      --with-libnet-includes=#{libnet.opt_include}
      --with-libnet-libraries=#{libnet.opt_lib}
    ]

    if OS.mac?
      args << "--enable-ipfw"
      # Workaround for dyld[98347]: symbol not found in flat namespace '_iconv'
      ENV.append "LIBS", "-liconv" if MacOS.version >= :monterey
    else
      args << "--with-libpcap-includes=#{Formula["libpcap"].opt_include}"
      args << "--with-libpcap-libraries=#{Formula["libpcap"].opt_lib}"
    end

    inreplace "configure", "for ac_prog in python3 ", "for ac_prog in python3.11 "
    system "./configure", *std_configure_args, *args
    system "make", "install-full"

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: lib/"suricata/python")

    # Leave the magic-file: prefix in otherwise it overrides a commented out line rather than intended line.
    inreplace etc/"suricata/suricata.yaml", %r{magic-file: /.+/magic}, "magic-file: #{libmagic.opt_share}/misc/magic"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/suricata --build-info")
    assert_match "Found Suricata", shell_output("#{bin}/suricata-update list-sources")
  end
end
