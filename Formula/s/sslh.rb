class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v2.1.4.tar.gz"
  sha256 "c9d76a627839b5f779e21dd49c40762918f47b46197418b3715ec0c52e3c5cb7"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  head "https://github.com/yrutschle/sslh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9ffce8f7acbb17eccb7b998789b299562f3fa8c3f74d08478657309b514b93a4"
    sha256 cellar: :any,                 arm64_sonoma:  "e4f05c08d30f736361c1715449895516a8a3327d4f964a7fc3cb9a89bb1cdec4"
    sha256 cellar: :any,                 arm64_ventura: "e4afb69a6efed5c7eab76e8df5e30fc2cb8c19e27d6f1d1409d0298f8fdafd53"
    sha256 cellar: :any,                 sonoma:        "17a668ad78929b1ea207279c0f12d2c7be04e0a0e9d6aabc9e9a44c336691dbc"
    sha256 cellar: :any,                 ventura:       "da63de34dec87066332f8cb6520ad897242ac4cfac09b851aab81ec43d393f18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "364c9146c23390ab94bd76339a2ff5d0ded405381379eb16e4a0dfe631a8c0e0"
  end

  depends_on "libconfig"
  depends_on "libev"
  depends_on "pcre2"

  uses_from_macos "netcat" => :test

  def install
    system "./configure", *std_configure_args
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    listen_port = free_port
    target_port = free_port

    spawn sbin/"sslh", "--http=localhost:#{target_port}", "--listen=localhost:#{listen_port}", "--foreground"

    sleep 1
    sleep 5 if OS.mac? && Hardware::CPU.intel?
    system "nc", "-z", "localhost", listen_port
  end
end
