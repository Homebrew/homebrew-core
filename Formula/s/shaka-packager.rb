class ShakaPackager < Formula
  desc "Tool and media packaging SDK for DASH and HLS packaging and encryption"
  homepage "https://shaka-project.github.io/shaka-packager/"
  url "https://github.com/shaka-project/shaka-packager.git",
    tag: "v3.5.0",
    revision: "3fc16608677bfa40568601399ce19d9e22e0a205"
  license "BSD-3-Clause"
  head "https://github.com/shaka-project/shaka-packager.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    args = %w[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DBUILD_SHARED_LIBS=OFF
      -DFULLY_STATIC=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args, *std_cmake_args
    system "cmake", "--build", "build", "--config", "Release"
    system "cmake", "--install", "build", "--strip", "--config", "Release"
  end

  test do
    resource "testdata" do
      url "https://github.com/mediaelement/mediaelement-files/raw/refs/heads/master/big_buck_bunny.mp4"
      sha256 "543a4ad9fef4c9e0004ec9482cb7225c2574b0f889291e8270b1c4d61dbc1ab8"
    end

    resource("testdata").stage do
      assert_match "Packaging completed successfully", shell_output("#{bin}/packager \
        input=big_buck_bunny.mp4,stream=video,output=big_buck_bunny.mp4 \
        --enable_raw_key_decryption \
        --keys label=SD:key=6143b5373a51cb46209cfed0d747da66:key_id=2c7ed98f472124deafe1dfeba2b45a34")
    end
  end
end
