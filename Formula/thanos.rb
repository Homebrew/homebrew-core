class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https://thanos.io"
  url "https://github.com/thanos-io/thanos/archive/v0.17.1.tar.gz"
  sha256 "29fc5ec6250333e8ce60e922d08539ca236ca8286ad3b416242c9c1a469a2733"
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
