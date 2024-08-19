class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://code.videolan.org/videolan/x264.git",
      revision: "31e19f92f00c7003fa115047ce50978bc98c3a0d"
  version "r3108"
  license "GPL-2.0-only"
  head "https://code.videolan.org/videolan/x264.git", branch: "master"

  # Cross-check the abbreviated commit hashes from the release filenames with
  # the latest commits in the `stable` Git branch:
  # https://code.videolan.org/videolan/x264/-/commits/stable
  livecheck do
    url "https://artifacts.videolan.org/x264/release-macos-arm64/"
    regex(%r{href=.*?x264[._-](r\d+)[._-]([\da-z]+)/?["' >]}i)
    strategy :page_match do |page, regex|
      # Match the version and abbreviated commit hash in filenames
      matches = page.scan(regex)

      # Fetch the `stable` Git branch Atom feed
      stable_page_data = Homebrew::Livecheck::Strategy.page_content("https://code.videolan.org/videolan/x264/-/commits/stable?format=atom")
      next if stable_page_data[:content].blank?

      # Extract commit hashes from the feed content
      commit_hashes = stable_page_data[:content].scan(%r{/commit/([\da-z]+)}i).flatten
      next if commit_hashes.blank?

      # Only keep versions with a matching commit hash in the `stable` branch
      matches.map do |match|
        release_hash = match[1]
        commit_in_stable = commit_hashes.any? do |commit_hash|
          commit_hash.start_with?(release_hash)
        end

        match[0] if commit_in_stable
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "19910a7d287524c93e7c56e30eca711618e0b568c0a9a4462924b76761840fd5"
    sha256 cellar: :any,                 arm64_ventura:  "65babfc775b28b5d51d5acece8eb62ef377869964f088385cd09668848b63853"
    sha256 cellar: :any,                 arm64_monterey: "629c423cef3f124d566e852d72a7d27b48370463c7501f3c99879f5eab68ae20"
    sha256 cellar: :any,                 sonoma:         "815879af6a928c8c92730a0fd92e6633b3c77e1c17a2156865769d5f03207c7d"
    sha256 cellar: :any,                 ventura:        "6477590c867a8e4f016cd5562eb55bd45dd51acbd8aac5476bcd95a810dc2c80"
    sha256 cellar: :any,                 monterey:       "3b19033d9ff3b40030f1fb721c68e6ec308bb978d0a16af6951ab2aff004a94f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeeb090700f4e1fdf948ed265f6b63353aea4980709d05b6a9314473fd1c802e"
  end

  on_macos do
    depends_on "gcc" if DevelopmentTools.clang_build_version <= 902
  end

  on_intel do
    depends_on "nasm" => :build
  end

  # https://code.videolan.org/videolan/x264/-/commit/b5bc5d69c580429ff716bafcd43655e855c31b02
  fails_with :clang do
    build 902
    cause "Stack realignment requires newer Clang"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-lsmash
      --disable-swscale
      --disable-ffms
      --enable-shared
      --enable-static
      --enable-strip
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s.delete("r"), shell_output("#{bin}/x264 --version").lines.first
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <x264.h>

      int main()
      {
          x264_picture_t pic;
          x264_picture_init(&pic);
          x264_picture_alloc(&pic, 1, 1, 1);
          x264_picture_clean(&pic);
          return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "test.c", "-lx264", "-o", "test"
    system "./test"
  end
end
