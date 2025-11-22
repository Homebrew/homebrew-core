class ShakaPackager < Formula
  desc "Tool and media packaging SDK for DASH and HLS packaging and encryption"
  homepage "https://github.com/shaka-project/shaka-packager"
  url "https://github.com/shaka-project/shaka-packager.git",
    tag:      "v3.4.2",
    revision: "c819deaa2376399a89d41f3804bc72f4a20d9d6d"
  license "BSD-3-Clause"
  head "https://github.com/shaka-project/shaka-packager.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    #if !build.head? && MacOS.version >= :tahoe
      # see: https://github.com/shaka-project/shaka-packager/commit/7cd7e48e9cfd008542c2f7c7c292bde15837a15e
      # system "git", "checkout", "v3.4.2"
      system "git", "cherry-pick", "--strategy-option=theirs", "7cd7e48e9cfd008542c2f7c7c292bde15837a15e"
      #end

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
    # TODO:
    # use this one: https://github.com/axiomatic-systems/Bento4/blob/master/Test/Data/audio-aac-002.mp4
    # # encrypt it and then decrypt it
    # # and check that the file is still the same after both operations
    system true
  end
end
