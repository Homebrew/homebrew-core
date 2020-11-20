class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.17.0.tar.gz"
  sha256 "36c2bbe5f96d0032d7bdfb535132ed78652e4a16cb0b29711f0a7ad63f468ed3"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9069ed484aec2f1649e6c4c754f310d06b04516fba6ac6a961f6e8becf8c635" => :big_sur
    sha256 "03b5bd7d8a5b2f71874d6d6598a6ae22f13b1a3603f1334e77e2a35e44bd651e" => :catalina
    sha256 "801caa715d91550fe5ec2a9a141d895185aabc5cfef1b662272d17a878718ed0" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/thanos"
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
