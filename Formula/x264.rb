class X264 < Formula
  desc "H.264/AVC encoder"
  homepage "https://www.videolan.org/developers/x264.html"
  license "GPL-2.0-only"
  head "https://code.videolan.org/videolan/x264.git", branch: "master"

  stable do
    # the latest commit on the stable branch
    url "https://code.videolan.org/videolan/x264.git",
        revision: "5db6aa6cab1b146e07b60cc1736a01f21da01154"
    version "r3060"
  end

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
      next [] if stable_page_data[:content].blank?

      # Extract commit hashes from the feed content
      commit_hashes = stable_page_data[:content].scan(%r{/commit/([\da-z]+)}i).flatten
      next [] if commit_hashes.blank?

      # Only keep versions with a matching commit hash in the `stable` branch
      matches.map do |match|
        next nil unless match.length >= 2

        release_hash = match[1]
        commit_in_stable = false
        commit_hashes.each do |commit_hash|
          next unless commit_hash.start_with?(release_hash)

          commit_in_stable = true
          break
        end

        commit_in_stable ? match[0] : nil
      end.compact
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9734de08ad24836dc4c222293d6413b66d0e2f7b5dd93fc190e3404f316f3804"
    sha256 cellar: :any,                 arm64_big_sur:  "2f5442c86dc08c7c283a4de626e8a7e8ceb17621b2ce63c7674f8c31a47eaf2c"
    sha256 cellar: :any,                 monterey:       "40eca7e7d71bb3541b5dceb89bd5b40b0bd763e30ab0f36e6d7a405309eda270"
    sha256 cellar: :any,                 big_sur:        "dae0e0e0715c44a916170879eb71c942b673d9450c7c0db319ce7e56757e567f"
    sha256 cellar: :any,                 catalina:       "2ffa8448569c0272db62789e0c1475330356956f570fea278a3fa0ca7739ab3b"
    sha256 cellar: :any,                 mojave:         "6780344c98d8c614d8fb8039365747cc699cb6818f7c3d56b708d9e2c5afe388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ed86de1b2e5af0136202b8479dde1935c46bbdd9da4c11afa52f1f18820e9a1"
  end

  depends_on "nasm" => :build

  if MacOS.version <= :high_sierra
    # Stack realignment requires newer Clang
    # https://code.videolan.org/videolan/x264/-/commit/b5bc5d69c580429ff716bafcd43655e855c31b02
    depends_on "gcc"
    fails_with :clang
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
