class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "26.4.0",
      revision: "c5add450714feaf941dc666ab7bb35ad544e56fd"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffd8afb5660a42d31c79a06659f7a63e9e40298e7f9607b49c557ca66ae16752"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffd8afb5660a42d31c79a06659f7a63e9e40298e7f9607b49c557ca66ae16752"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffd8afb5660a42d31c79a06659f7a63e9e40298e7f9607b49c557ca66ae16752"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffd8afb5660a42d31c79a06659f7a63e9e40298e7f9607b49c557ca66ae16752"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f3cd3bfcd0468bccd927dce2310a62544bd22d6785e9e8e3a05149f27363e6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f3cd3bfcd0468bccd927dce2310a62544bd22d6785e9e8e3a05149f27363e6d"
  end

  depends_on "gradle@8" => :build
  depends_on "openjdk"

  def install
    system "gradle", "installDist"

    libexec.install Dir["build/install/teku/*"]

    (bin/"teku").write_env_script libexec/"bin/teku", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "teku/", shell_output("#{bin}/teku --version")

    rest_port = free_port
    test_args = %W[
      --network=minimal
      --Xinterop-enabled
      --Xinterop-number-of-validators=8
      --rest-api-enabled
      --rest-api-port=#{rest_port}
      --p2p-enabled=false
      --data-path=#{testpath}
    ]
    spawn bin/"teku", *test_args
    sleep 15

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{rest_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
