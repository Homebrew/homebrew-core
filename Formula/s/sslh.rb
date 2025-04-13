class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v2.2.1.tar.gz"
  sha256 "ae4d1a2969a9cc205a35247b4fcdb7f84886048fbe2d8b2ea41b0cadad92e48c"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  head "https://github.com/yrutschle/sslh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0f9562442cd5d0acc55c2513b8ae1ffe28aa3d556e52ae31ed0fc21d203b66ac"
    sha256 cellar: :any,                 arm64_sonoma:  "42ab665062f4ac9f33fbdda827168fbb5aeb2f4ce9fea774559eaacb1255791d"
    sha256 cellar: :any,                 arm64_ventura: "1ddb03eecabef2212779909aa7037e1f5852cc1f237b7154d3dd751b95d80481"
    sha256 cellar: :any,                 sonoma:        "a6b4f18dc5fe234e21fdc7d9b8cd77a019878aa5cfb8c4dfeec5c1146637959f"
    sha256 cellar: :any,                 ventura:       "3f4eb8a4c365db6e8b1b562e7024cb5bfdda80814d2b36b54cb501811630265d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e63b78ada3901687aff2e8f6bcc878e777364cb5b37951e47afb0d35627a8743"
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
