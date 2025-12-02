class Xauth < Formula
  desc "X.Org Applications: xauth"
  homepage "https://www.x.org/"
  url "https://www.x.org/pub/individual/app/xauth-1.1.4.tar.xz"
  sha256 "e9318141464ad7b4dc0f8564a580f0d20f977c85a388cc40d5a766206151c690"
  license "MIT-open-group"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "482732473b597b69803aa752a8b3e81727ef704ea114afaba8189ec8f8174b5d"
    sha256 cellar: :any,                 arm64_sequoia: "5a9d8f5e963c19c5245d33ea579cc87384a2e0d6e50d34979dccabd027efc3c1"
    sha256 cellar: :any,                 arm64_sonoma:  "8a24eae57487dfa2e9eea59f32f921da0f80e6d5cf6cae52683b0d1da150c4f2"
    sha256 cellar: :any,                 arm64_ventura: "1c8d12d20eec9be0585b8c6bd44b36929c4cd2b6f1598148e490d3a388d36edc"
    sha256 cellar: :any,                 sonoma:        "9dde39c14d1fad1e94571a181c8fa62f1a944c9ff332873a8e149a179a93f6dc"
    sha256 cellar: :any,                 ventura:       "69af4439e0d66e4f233a1eb679754c388e3bc0ab79912e15760bddb6648fde31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e192fd49a6a232b2002d8835654499c2a01a34332f157e127c6b5269fb3b05f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a562860d2d2ed8bec6fd14a4929e3be833423fb707ae79fdab37c190ed97e5ff"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxext"
  depends_on "libxmu"

  on_linux do
    depends_on "libxcb"
    depends_on "libxdmcp"
  end

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-unix-transport
      --enable-tcp-transport
      --enable-ipv6
      --enable-local-transport
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "unable to open display", shell_output("#{bin}/xauth generate :0 2>&1", 1)
  end
end
