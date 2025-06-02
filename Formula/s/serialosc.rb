class Serialosc < Formula
  desc "Opensound control server for monome devices"
  homepage "https://github.com/monome/docs/blob/gh-pages/serialosc/osc.md"
  # pull from git tag to get submodules
  url "https://github.com/monome/serialosc.git",
      tag:      "v1.4.5",
      revision: "79ac58b0737bc8a6617d90ab41fb00b791a5a746"
  license "ISC"
  head "https://github.com/monome/serialosc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b1ba9d4682993c2b91b290ae127d7d3b4f9bf824096990f70680651a79390459"
    sha256 cellar: :any,                 arm64_sonoma:  "84e6065faa98dbfb31e366907c0ad337472165ccffb3c8299cf2649811d19d6b"
    sha256 cellar: :any,                 arm64_ventura: "f52aa361a0b6fcd4636a6e98d7b14d720ada9da0f2a78389f94296a54532d294"
    sha256 cellar: :any,                 sonoma:        "594dd66c1a55996360013bad6a3f6fe042a5ee853b855b19e8703e0b501ac5cd"
    sha256 cellar: :any,                 ventura:       "20f48d409724d37c319fd7595e47cc051be3e4343771168dfecbb9cd83e420d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b01477de4be9295d6c2997b07611a4d52428a819bd5662b34f04d55e110c8b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b66b2d89de42e40b3f3659dbb4f461698d0ff515047af8fd58ca543efe2757c"
  end

  depends_on "confuse"
  depends_on "liblo"
  depends_on "libmonome"
  depends_on "libuv"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "avahi"
    depends_on "systemd" # for libudev
  end

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"
  end

  service do
    run [opt_bin/"serialoscd"]
    keep_alive true
    log_path var/"log/serialoscd.log"
    error_log_path var/"log/serialoscd.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serialoscd -v")
  end
end
