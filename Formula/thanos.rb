class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.23.1.tar.gz"
  sha256 "265bfda3f6b841489f3a75faeb5c981618f5d8eb91d25b9ec5cbe1642e78787c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f2e46b7f6bc010dc497bb13b4b8802508c83fd902e41eef7392af115ba6bb23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "599c986b920324ff984453df7062f77649c823c0f061077b1d57760096541bf3"
    sha256 cellar: :any_skip_relocation, monterey:       "0045362fcd3a887da1778768366a55d1c0a92e37a4ebcc889d2537744370de1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "27da4616f608481ec634063e17b6dccfef535399c0029e9276dc6714490c808f"
    sha256 cellar: :any_skip_relocation, catalina:       "98d1a9fdb318304f45cbb140910226a8e0c226772c906d233c8f4ab55b04a578"
    sha256 cellar: :any_skip_relocation, mojave:         "08573637faf2e9815f8f3a4395b0a2c84229f4d079813598b76488f0d8f1907c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea78a53362c50e519b31ad641da5052d14a6383b19df11909d3259d4b90cac3c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/thanos"
  end

  test do
    (testpath/"bucket_config.yaml").write <<~EOS
      type: FILESYSTEM
      config:
        directory: #{testpath}
    EOS

    output = shell_output("#{bin}/thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end
