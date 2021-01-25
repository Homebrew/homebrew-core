class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://rakudo.org/dl/star/rakudo-star-2020.10.tar.gz"
  sha256 "b5742c40bd25e582bed29c994802781d76ca204be1bccafd48dbf3056f6dcf6b"
  license "Artistic-2.0"

  livecheck do
    url "https://rakudo.org/dl/star/"
    regex(/".*?rakudo-star[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "aeb7eb041a03204bf11a556e24a6da57d0b9eb55ec8c6179f54e6f6b0b8d44cd" => :big_sur
    sha256 "1a9933d90e4c95b895cc712f267bf38ad4bf40c0170869e46ebe9dc35855f9d0" => :catalina
    sha256 "3d8cb747d9a1c9131637cc25b8fc32c6844a9113096eb3a9ccb28c6d69ea363f" => :mojave
    sha256 "6fc9f0fe77b7a692431d85199633353df82b6c409dc754162c04d0ae26843b87" => :high_sierra
  end

  depends_on "bash" => :build
  depends_on "gmp"
  depends_on "icu4c"
  depends_on "libffi"
  depends_on "pcre"
  depends_on "readline"

  conflicts_with "moarvm", "nqp", because: "rakudo-star currently ships with moarvm and nqp included"
  conflicts_with "parrot"
  conflicts_with "rakudo"

  # Patch to resolve references to the Homebrew shims directory. This has been fixed
  # upstream in https://github.com/rakudo/rakudo/commit/dd0a2a15c6fd79c2e8ff75bb1bd0684ef612a1ea
  # so this patch can be removed for the next rakudo-star release.
  patch :DATA

  def install
    libffi = Formula["libffi"]
    ENV.remove "CPPFLAGS", "-I#{libffi.include}"
    ENV.prepend "CPPFLAGS", "-I#{libffi.lib}/libffi-#{libffi.version}/include"

    ENV.deparallelize # An intermittent race condition causes random build failures.

    # make install runs tests that can hang on sierra
    # set this variable to skip those tests
    ENV["NO_NETWORK_TESTING"] = "1"
    system "bin/rstar", "install", "-p", prefix.to_s

    #  Installed scripts are now in share/perl/{site|vendor}/bin, so we need to symlink it too.
    bin.install_symlink Dir[share/"perl6/vendor/bin/*"]
    bin.install_symlink Dir[share/"perl6/site/bin/*"]

    # Move the man pages out of the top level into share.
    # Not all backends seem to generate man pages at this point (moar does not, parrot does),
    # so we need to check if the directory exists first.
    mv "#{prefix}/man", share if File.directory?("#{prefix}/man")
  end

  test do
    out = `#{bin}/raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'`
    assert_equal "0123456789", out
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end

__END__

diff --git a/src/rakudo-2020.10/rakudo-2020.10/lib/Test.rakumod b/src/rakudo-2020.10/rakudo-2020.10/lib/Test.rakumod
index e8548aac6..f1f706658 100644
--- a/src/rakudo-2020.10/rakudo-2020.10/lib/Test.rakumod
+++ b/src/rakudo-2020.10/rakudo-2020.10/lib/Test.rakumod
@@ -4,11 +4,10 @@ unit module Test;
 # Copyright (C) 2007 - 2020 The Perl Foundation.
 
 # settable from outside
-my %ENV := %*ENV;  # reduce dynamic lookups
-my int $perl6_test_times =
-  ?(%ENV<RAKU_TEST_TIME> // %ENV<PERL6_TEST_TIMES>);
+my int $raku_test_times =
+  ?(%*ENV<RAKU_TEST_TIME> // %*ENV<PERL6_TEST_TIMES>);
 my int $die_on_fail =
-  ?(%ENV<RAKU_TEST_DIE_ON_FAIL> // %ENV<PERL6_TEST_DIE_ON_FAIL>);
+  ?(%*ENV<RAKU_TEST_DIE_ON_FAIL> // %*ENV<PERL6_TEST_DIE_ON_FAIL>);
 
 # global state
 my @vars;
@@ -113,7 +112,7 @@ multi sub plan($number_of_tests) is export {
     $time_before = nqp::time_n;
     $time_after  = nqp::time_n;
     $str-message ~= "\n$indents# between two timestamps " ~ ceiling(($time_after-$time_before)*1_000_000) ~ ' microseconds'
-        if nqp::iseq_i($perl6_test_times,1);
+        if nqp::iseq_i($raku_test_times,1);
 
     $output.say: $str-message;
 
@@ -691,7 +690,7 @@ sub _is_deeply(Mu $got, Mu $expected) {
 sub die-on-fail {
     if !$todo_reason && !$subtest_level && nqp::iseq_i($die_on_fail,1) {
         _diag 'Test failed. Stopping test suite, because the '
-          ~ (%ENV<RAKU_TEST_DIE_ON_FAIL> ?? 'RAKU' !! 'PERL6')
+          ~ (%*ENV<RAKU_TEST_DIE_ON_FAIL> ?? 'RAKU' !! 'PERL6')
           ~ "_TEST_DIE_ON_FAIL\n"
           ~ 'environmental variable is set to a true value.';
         exit 255;
@@ -749,7 +748,7 @@ sub proclaim(Bool(Mu) $cond, $desc is copy, $unescaped-prefix = '') {
             !! "ok $num_of_tests_run - $unescaped-prefix$desc";
 
     $tap ~= ("\n$indents# t=" ~ ceiling(($time_after - $time_before)*1_000_000))
-        if nqp::iseq_i($perl6_test_times,1);
+        if nqp::iseq_i($raku_test_times,1);
 
     $output.say: $tap;
 
