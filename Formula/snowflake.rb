class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitweb.torproject.org/pluggable-transports/snowflake.git/snapshot/snowflake-2.4.2.tar.gz"
  sha256 "f4b5a041d3785e030599928d1de461d8aded6c560bb669d40f9071b1ef9fb769"
  license "BSD-3-Clause"
  head "https://git.torproject.org/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10e7c4120adf86e122ac7d4cb026f6bb9cfd46e6f93b6ca5e596ae07a7f6fabd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f93d447d7dc0ce61dc9816ba9bc877baa88b83220d2e7bda4eb6fd30a8c2a51f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afbd3d72dfcb082e3636d5eb84b87a4c704db528fdd4eefb4f06777090801f6a"
    sha256 cellar: :any_skip_relocation, ventura:        "e50a96234f648da82dd8493fa08427ca855df24da58cfb15c711316aa09cc090"
    sha256 cellar: :any_skip_relocation, monterey:       "1b166f9261ba88519c17dfcb914d18dfa72c0ea1fb2abecc1efa3f90250b6856"
    sha256 cellar: :any_skip_relocation, big_sur:        "b52c9538018a19e103aab0e55817fc245fb2ebba4762148a387df1d9c99a78e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ffe93c871a3f65837b167d9dc1fcb564b620d76c8b0aca79ea550b59067401f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"snowflake-broker"), "./broker"
    system "go", "build", *std_go_args(output: bin/"snowflake-client"), "./client"
    system "go", "build", *std_go_args(output: bin/"snowflake-proxy"), "./proxy"
    system "go", "build", *std_go_args(output: bin/"snowflake-server"), "./server"
    man1.install "doc/snowflake-client.1"
    man1.install "doc/snowflake-proxy.1"
  end

  test do
    assert_match "open /usr/share/tor/geoip: no such file", shell_output("#{bin}/snowflake-broker 2>&1", 1)
    assert_match "ENV-ERROR no TOR_PT_MANAGED_TRANSPORT_VER", shell_output("#{bin}/snowflake-client 2>&1", 1)
    assert_match "the --acme-hostnames option is required", shell_output("#{bin}/snowflake-server 2>&1", 1)
  end
end
