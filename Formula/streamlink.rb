class Streamlink < Formula
  desc "CLI for extracting streams from various websites to a video player"
  homepage "https://streamlink.github.io/"
  url "https://github.com/streamlink/streamlink/releases/download/0.14.2/streamlink-0.14.2.tar.gz"
  sha256 "a8c7f9a758ade056a35d439f78408e9e43ce1069dde9289d322702d35c214150"
  revision 1

  bottle do
    cellar :any
    sha256 "c4a96191f6db7355541deb480c22d9257536902b2f734917efa2ceab50410a45" => :mojave
    sha256 "c22ef0ffd0a93c276ea06b57ea98fab25ed7fd2faeabeee46fe50802382c56cb" => :high_sierra
    sha256 "bbc2bf85d06976e7bdee912a2e8c3f3ed9509c726eaebb1f11eedfce7fd6f760" => :sierra
  end

  depends_on "python"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/4d/9c/46e950a6f4d6b4be571ddcae21e7bc846fcbb88f1de3eff0f6dd0a6be55d/certifi-2018.4.16.tar.gz"
    sha256 "13e698f54293db9f89122b0581843a782ad0934a4fe0172d2a980ba77fc61bb7"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"
    sha256 "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ec/b2/faa78c1ab928d2b2c634c8b41ff1181f0abdd9adf9193211bd606ffa57e2/cryptography-2.2.2.tar.gz"
    sha256 "9fc295bf69130a342e7a19a39d7bbeb15c0bcaabc7382ec33ef3b2b7d18d2f63"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/97/8d/77b8cedcfbf93676148518036c6b1ce7f8e14bf07e95d7fd4ddcb8cc052f/ipaddress-1.0.22.tar.gz"
    sha256 "b146c751ea45cad6188dd6cf2d9b757f6f4f8d6ffb96a023e6f2e26eea02a72c"
  end

  resource "iso-639" do
    url "https://files.pythonhosted.org/packages/5a/8d/27969852f4e664525c3d070e44b2b719bc195f4d18c311c52e57bb93614e/iso-639-0.4.5.tar.gz"
    sha256 "dc9cd4b880b898d774c47fe9775167404af8a85dd889d58f9008035109acce49"
  end

  resource "iso3166" do
    url "https://files.pythonhosted.org/packages/46/06/64145b8d6be8474db1f09f6b01a083921c11a4c979d029677c7e943d2433/iso3166-0.8.tar.gz"
    sha256 "fbeb17bed90d15b1f6d6794aa2ea458e5e273a1d29b6f4939423c97640e14933"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/00/cc/c623e25aa38e947a449a9b67c3a1c65f2db56aeb43b541cb197dc659f78d/pycryptodome-3.6.3.tar.gz"
    sha256 "9b2e142322273ee88c96ade5cfc0ff99b759be32a06d49ce55cd39adeb1e4541"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/9b/7c/ee600b2a9304d260d96044ab5c5e57aa489755b92bbeb4c0803f9504f480/pyOpenSSL-18.0.0.tar.gz"
    sha256 "6488f1423b00f73b7ad5167885312bb0ce410d3312eb212393795b53c8caa580"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/53/12/6bf1d764f128636cef7408e8156b7235b150ea31650d0260969215bb8e7d/PySocks-1.6.8.tar.gz"
    sha256 "3fe52c55890a248676fd69dc9e3c4e811718b777834bcaab7a8125cf9deac672"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/54/1f/782a5734931ddf2e1494e4cd615a51ff98e1879cbe9eecbdfeaf09aa75e9/requests-2.19.1.tar.gz"
    sha256 "ec22d826a36ed72a7358ff3fe56cbd4ba69dd7a6718ffd450ff0e9df7a47ce6a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/28/85/df04ec21c622728316b591c2852fd20a0e74324eeb6ca26f351844ba815f/websocket_client-0.48.0.tar.gz"
    sha256 "18f1170e6a1b5463986739d9fd45c4308b0d025c1b2f9b88788d8f69e8a5eb4a"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/streamlink", "https://www.youtube.com/watch?v=he2a4xK8ctk", "144p", "-o", "video.mp4"
    assert_match "video.mp4: ISO Media, MPEG v4 system, 3GPP", shell_output("file video.mp4")
  end
end
