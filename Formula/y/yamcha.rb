class Yamcha < Formula
  desc "NLP text chunker using Support Vector Machines"
  homepage "http://chasen.org/~taku/software/yamcha/"
  url "http://chasen.org/~taku/software/yamcha/src/yamcha-0.33.tar.gz"
  sha256 "413d4fc0a4c13895f5eb1468e15c9d2828151882f27aea4daf2399c876be27d5"
  license "LGPL-2.1"

  livecheck do
    url :homepage
    regex(/href=.*?yamcha[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "2302fc8b966f2d6cd48fdffdf765d577844e571a7f7de14aa1fe4091f960e329"
    sha256 cellar: :any,                 arm64_monterey: "f3b51abc7335c21295ed08c9142d9c8fe2b48a74d8d632b5bc7812079938ba80"
    sha256 cellar: :any,                 arm64_big_sur:  "69a10b712ef5d0d47b50623eba38fe14207b046e6b55156cfc5f5595d0983161"
    sha256 cellar: :any,                 ventura:        "f8db88401507cec60953241a6ea12bc3945dcb68db85366bc597f466664badb7"
    sha256 cellar: :any,                 monterey:       "31ace70fbbf4e2da60850ccc2cea0bd4131e6acc98560cb3230d38c334ec2d2d"
    sha256 cellar: :any,                 big_sur:        "18f032ddd520debefef3e67422089660c9222e1a8098d4c9b5128cb7a517e87a"
    sha256 cellar: :any,                 catalina:       "703da9d88502c3e8ede9d567a816f7b7856112175f07f8b4c720bc7b0f540e64"
    sha256 cellar: :any,                 mojave:         "37ce1ca98c2de4978de9d8877752570680fffae4c41026c5e560c83b5f4b3473"
    sha256 cellar: :any,                 high_sierra:    "003ba175b22691b3ced58178504a83bda7455cfd599685c0e002ccbf91efb88d"
    sha256 cellar: :any,                 sierra:         "b9f2e9521d25dafc70617857f32b1742b8bb29046b3ea930eafb3261a0727e36"
    sha256 cellar: :any,                 el_capitan:     "b65fade9c6ddcced1d3c3fc6700f18ed2ddd16b62437fc71f9a85a3568851520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ce0b05c30bff796b1ed14c7732670d3fd9b96a20f3b48e1f4953b3e8c9d745c"
  end

  depends_on "tinysvm"

  on_arm do
    # Added automake as a build dependency to update config files for ARM support.
    depends_on "automake" => :build
  end

  # Fix build failure because of missing #include <cstring>/"stdlib.h" on Linux.
  # Patch submitted to author by email.
  patch :DATA

  def install
    if Hardware::CPU.arm?
      # Workaround for ancient config files not recognizing aarch64 macos.
      %w[config.guess config.sub].each do |fn|
        cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, fn
      end
    end
    ENV.append "CPPFLAGS", "-std=c++03" if OS.linux?
    system "./configure", *std_configure_args, "--mandir=#{man}"
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
      assert_predicate testpath/"case_study.#{ext}", :exist?
    end
  end
end

__END__
diff --git a/libexec/mkdarts.cpp b/libexec/mkdarts.cpp
index c012fec..b88bdff 100644
--- a/libexec/mkdarts.cpp
+++ b/libexec/mkdarts.cpp
@@ -23,6 +23,7 @@
 
 #include <cstdio>
 #include <cstring>
+#include <cstdlib>
 #include <iostream>
 #include <fstream>
 #include <string>
diff --git a/src/param.cpp b/src/param.cpp
index bbf7761..053e3c8 100644
--- a/src/param.cpp
+++ b/src/param.cpp
@@ -26,6 +26,7 @@
 #include <cstdio>
 #include "param.h"
 #include "common.h"
+#include "string.h"
 
 #ifdef HAVE_CONFIG_H
 #include "config.h"
