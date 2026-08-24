class Yamcha < Formula
  desc "NLP text chunker using Support Vector Machines"
  homepage "http://chasen.org/~taku/software/yamcha/"
  # Upstream is only available via HTTP, so we prefer pkgsrc's HTTPS mirror
  url "https://cdn.netbsd.org/pub/pkgsrc/distfiles/yamcha-0.33.tar.gz"
  mirror "http://chasen.org/~taku/software/yamcha/src/yamcha-0.33.tar.gz"
  sha256 "413d4fc0a4c13895f5eb1468e15c9d2828151882f27aea4daf2399c876be27d5"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "f79875ac74e46f3087379d783513f73971707f8d0ff059e050f1256d5535a827"
    sha256 cellar: :any,                 arm64_sequoia:  "1291bdd640d66cfbbe073862038e660ada3fe9377d3386db32dd56967ee23d5f"
    sha256 cellar: :any,                 arm64_sonoma:   "d71664644d8b49088b1de03d5f5edfa3dbbdde0a45bcd88b50c50e003e44e191"
    sha256 cellar: :any,                 arm64_ventura:  "2302fc8b966f2d6cd48fdffdf765d577844e571a7f7de14aa1fe4091f960e329"
    sha256 cellar: :any,                 arm64_monterey: "f3b51abc7335c21295ed08c9142d9c8fe2b48a74d8d632b5bc7812079938ba80"
    sha256 cellar: :any,                 arm64_big_sur:  "69a10b712ef5d0d47b50623eba38fe14207b046e6b55156cfc5f5595d0983161"
    sha256 cellar: :any,                 sonoma:         "aec22c106760679ed09434e1105fd60311162b2a8e6d6f5bf06b8fa88caff47f"
    sha256 cellar: :any,                 ventura:        "f8db88401507cec60953241a6ea12bc3945dcb68db85366bc597f466664badb7"
    sha256 cellar: :any,                 monterey:       "31ace70fbbf4e2da60850ccc2cea0bd4131e6acc98560cb3230d38c334ec2d2d"
    sha256 cellar: :any,                 big_sur:        "18f032ddd520debefef3e67422089660c9222e1a8098d4c9b5128cb7a517e87a"
    sha256 cellar: :any,                 catalina:       "703da9d88502c3e8ede9d567a816f7b7856112175f07f8b4c720bc7b0f540e64"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5ebf9b1d45af65bd57c866ec89a3ebe280571edb16d6a1d971c55c5ed3228ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ce0b05c30bff796b1ed14c7732670d3fd9b96a20f3b48e1f4953b3e8c9d745c"
  end

  # Last release on 2005-09-05
  deprecate! date: "2026-07-11", because: :unmaintained
  disable! date: "2026-10-11", because: :unmaintained

  depends_on "tinysvm"

  on_arm do
    # Added automake as a build dependency to update config files for ARM support.
    depends_on "automake" => :build
  end

  # Use Debian patch to fix error: no matching function for call to 'make_pair'
  patch do
    url "https://snapshot.debian.org/archive/debian-debug/20170926T092903Z/pool/main/y/yamcha/yamcha_0.33-2.debian.tar.xz"
    sha256 "6a114584af8256504a195e4164308bdd462d1e8860b77951431b4ca7de3a21e8"
    type :unofficial
    apply "patches/1011_fix_gcc7_compilation.patch"
  end

  def install
    if Hardware::CPU.arm?
      # Workaround for ancient config files not recognizing aarch64 macos.
      %w[config.guess config.sub].each do |fn|
        cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, fn
      end
    end

    # Work around failure because of missing #include <cstring>/<cstdlib> on Linux.
    ENV.append "CXX", "-include cstring -include cstdlib" if OS.linux?

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    libexecdir = shell_output("#{bin}/yamcha-config --libexecdir").chomp
    assert_equal libexecdir, "#{libexec}/yamcha"

    (testpath/"train.data").write <<~EOS
      He        PRP  B-NP
      reckons   VBZ  B-VP
      the       DT   B-NP
      current   JJ   I-NP
      account   NN   I-NP
      deficit   NN   I-NP
      will      MD   B-VP
      narrow    VB   I-VP
      to        TO   B-PP
      only      RB   B-NP
      #         #    I-NP
      1.8       CD   I-NP
      billion   CD   I-NP
      in        IN   B-PP
      September NNP  B-NP
      .         .    O

      He        PRP  B-NP
      reckons   VBZ  B-VP
      ..
    EOS

    system "make", "-j", "1",
                   "-f", "#{libexecdir}/Makefile",
                   "CORPUS=train.data", "MODEL=case_study", "train"

    %w[log model se svmdata txtmodel.gz].each do |ext|
      assert_path_exists testpath/"case_study.#{ext}"
    end
  end
end
