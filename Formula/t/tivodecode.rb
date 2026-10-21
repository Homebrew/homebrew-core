class Tivodecode < Formula
  desc "Convert .tivo to .mpeg"
  homepage "https://tivodecode.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/tivodecode/tivodecode/0.2pre4/tivodecode-0.2pre4.tar.gz"
  sha256 "788839cc4ad66f5b20792e166514411705e8564f9f050584c54c3f1f452e9cdf"
  # The `:cannot_represent` is for the Turing encryption algorithm under a non-SPDX
  # QUALCOMM license which has similar restrictions to BSD-Systemics along with an
  # additional clause relating to the use of patented encryption algorithms.
  license all_of: ["BSD-3-Clause", :cannot_represent]

  livecheck do
    url :stable
    regex(%r{url=.*?/tivodecode[._-]v?(\d+(?:\.\d+)+(?:pre\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "96a9b6acfaf8bbf746191f95b0564ccb2d42ca4984b6fee2d263b65af76c1b6a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6aef5d85f98c48a4aa08864d14228ae5770baf31272041e54624ef837c977000"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "43393a250746ba85b622a828143a3a24a89d89ffb72b2c38d05161432fd73875"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "4c625902dffd6e9e9827abf8d13961e8863e191323b8b909f02358bef81ee5f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:     "edea82441461a1fb59d0b4ffff0c70063e2dd064bbcbaf7dd2f35a9fbc464602"
    sha256 cellar: :any_skip_relocation, arm64_monterey:    "d2289a446ab7ec226d1b6b3ddb042336d0a223009268984fa5d949394842e2e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:     "5171d7774e6eed485e7b3d57e3dd2b9bc0e935f97dd7890109ccdb3c4975ab62"
    sha256 cellar: :any_skip_relocation, sonoma:            "794351b4fb9c017c7d4c870ec11db2ecdfff74c0700ab310077045faf020a76d"
    sha256 cellar: :any_skip_relocation, ventura:           "2e6c1b18e7f2309d3ff7197901b23c59e548242cf2489daca28f0b8faca44ee5"
    sha256 cellar: :any_skip_relocation, monterey:          "dab7b05eb81397cfcb9e875a351d24d3a05741c77aaf28da7411318ef72dd770"
    sha256 cellar: :any_skip_relocation, big_sur:           "aeec3ab80bd78902f47343a699f3ebd4566b2d3fd9ce8076550bd705caf69486"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "69e56e2279ac41857a466d4eac31b69c6dfc3ad70899e26adb1908e39bdcf387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "28e4184504b5139d3532d972cad416bcd9188669c075681e36834f4e93d2b60d"
  end

  deny_network_access!

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    # Build a minimal TiVo file: 16-byte header, an XML chunk (key material),
    # an encrypted metadata chunk (id 1) and an unscrambled MPEG payload.
    tivo_file = lambda do |blob, payload|
      xml = '<?xml version="1.0"?><TvBusMarshalledStruct/>'
      chunks = [12 + xml.bytesize, xml.bytesize, 3, 0].pack("NNnn") + xml
      chunks += [12 + blob.bytesize, blob.bytesize, 1, 1].pack("NNnn") + blob
      ["TiVo", 4, 0x0d, 0, 16 + chunks.bytesize, 2].pack("a4nnnNn") + chunks + payload
    end

    (testpath/"plain.tivo").binwrite tivo_file.call("Homebrew metadata", "Homebrew TiVo payload\n")
    system bin/"tivodecode", "-m", "0123456789", "-o", "out.mpg", "plain.tivo"
    assert_equal "Homebrew TiVo payload\n", (testpath/"out.mpg").read

    # Turing is a stream cipher, so applying it twice restores the plaintext
    system bin/"tdcat", "-m", "0123456789", "-o", "enc.bin", "plain.tivo"
    encrypted = (testpath/"enc.bin").binread
    assert_equal "4f9f31fa29f8ee340da8413225fe5dd6e5", encrypted.unpack1("H*")

    (testpath/"enc.tivo").binwrite tivo_file.call(encrypted, "")
    system bin/"tdcat", "-m", "0123456789", "-o", "dec.bin", "enc.tivo"
    assert_equal "Homebrew metadata", (testpath/"dec.bin").read
  end
end
