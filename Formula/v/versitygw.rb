class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://github.com/versity/versitygw/archive/refs/tags/v1.0.15.tar.gz"
  sha256 "b1d877a30ea5b1d06cd50fd66500470664a1963b02fe4366d5fa8f301083b7db"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc89dc428ba0a92e0408db8e737f1676ec80fe2f751406b615891ed9691f9d52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42bd8256abfd14c0337f7ee1ac8d79548db17f94689f4433abd9dc745ce4429c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e638f5fde20e317301e52b6edd10db5e2e3cbf4937b3726bb7f5a50150e71020"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec8434722863c51c5ceb3fb3bdf2f7837ad62172be3836b3c79b733feda787c2"
    sha256 cellar: :any_skip_relocation, ventura:       "3c4d8032d92662fa171e2867b9f2ff2f92a7945f6d52d7257ad418b9fcfa8b77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bacf36b3462f9d20e0da31bec9c5fa8bde57ff112e117218e149fa54d75c04e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildTime=#{time.iso8601} -X main.Build=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/versitygw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/versitygw --version")

    system bin/"versitygw", "utils", "gen-event-filter-config"
    assert_equal true, JSON.parse((testpath/"event_config.json").read)["s3:ObjectAcl:Put"]

    output = shell_output("#{bin}/versitygw admin list-buckets 2>&1", 1)
    assert_match "Required flags \"access, secret, endpoint-url\"", output
  end
end
