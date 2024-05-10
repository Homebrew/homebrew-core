class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "a1da0b07de9afc5112a0212fa241995855bbf5fc090e36b9b51941dd814984b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26f5f6bc72852a37ccc6a3711d5f552971ec2cddd058e3e701253b7b2490d803"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7162e0f223aef7c191389c92446a35c09899daed24718dfe01a94ef3a87e5554"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "563654b569186424b6728da71f2e5e9ed03fdfad712ce267a3abc6e562f9318d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d2c112db1aed96f64df971ad2ba169b989fa7b4f4973ae855386bcd032b68e1"
    sha256 cellar: :any_skip_relocation, ventura:        "e93aef137d35df016bf12a7ff6c4baaf3aa08cf351e3c1f9900b6d649b2efdf2"
    sha256 cellar: :any_skip_relocation, monterey:       "08028767f8d1cea40159b0fa77a64a6953169dc8f7f110d5475b79b4b822836c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b32f64502b195f1c44dc07084f1765d800b53515f18422380713f9d9f910c8e"
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
