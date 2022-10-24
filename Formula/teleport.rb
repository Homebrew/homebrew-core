class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v11.0.0.tar.gz"
  sha256 "faa084977d6b0ddb022c28f41dd3b997b138b01a7e9e5518ee9e83649caefd06"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # We check the Git tags instead of using the `GithubLatest` strategy, as the
  # "latest" version can be incorrect. As of writing, two major versions of
  # `teleport` are being maintained side by side and the "latest" tag can point
  # to a release from the older major version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8fa641000b0021af66c14b4b49a1b07bf1736c1c25432c2037f4ea8d280a7b48"
    sha256 cellar: :any,                 arm64_monterey: "d8f9d15e0ea07c83e1814801e80b1bd5e9a8b7c8ab14b423d7caa893caa56335"
    sha256 cellar: :any,                 arm64_big_sur:  "85e66aa777c49d7204ccc817d025e1ad1054e5ec2252ee835cb54539c9f05427"
    sha256 cellar: :any,                 monterey:       "c6b9854a9bbed77c02688241e06fe8794f6ccaabb60794620df093b42ef49fde"
    sha256 cellar: :any,                 big_sur:        "8271ee841f17997cdec21e1fe35a1df981bc66357ab008e27a5fe4df56c66ccc"
    sha256 cellar: :any,                 catalina:       "6c79df95157d1f56c7d950d64e38ad4b98c9a7cf395777a285068e805606a827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac1ac14effa8813b2d95c6ff1cf984f7a028ac55a40e4c07f66064396c290a84"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libfido2"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/53bae5e9307323dca1e506337dcaefd7cc1573a9.tar.gz"
    sha256 "adaa169996a2b6bc2c1d45ed2a380ea0c63e8d958b560741509df1590d5b93f8"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build/*"]
  end

  test do
    curl_output = shell_output("curl \"https://api.github.com/repos/gravitational/teleport/contents/webassets?ref=v#{version}\"")
    assert_match JSON.parse(curl_output)["sha"], resource("webassets").url
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~EOS
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    EOS

    fork do
      exec "#{bin}/teleport start --roles=proxy,node,auth --config=#{testpath}/config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl --config=#{testpath}/config.yml status")
    assert_match(/Cluster\s*testhost/, status)
    assert_match(/Version\s*#{version}/, status)
  end
end
