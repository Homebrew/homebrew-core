class Vq < Formula
  desc "Utility for querying json"
  homepage "https://vqmind.github.io/vq/"
  url "https://github.com/vqmind/vq/releases/download/1.0.0/app-1.0.0.tar.gz"
  sha256 "057d570bd3a9522f6e392c3a5dbbf412d4cc676b16f752626b9acdc06438f3d3"
  license "MIT"

  depends_on "openjdk"

  def install
    prefix.install "app-#{version}.jar"

    (bin/"vq").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar #{prefix}/app-#{version}.jar "$@"
    EOS
  end

  test do
    assert_match "seattle", pipe_output("#{bin}/vq \"$.city\" ", "{\"city\":\"seattle\"}")
  end
end
