class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2019-12-01.tar.gz"
  version "20191201"
  sha256 "7268e1b4254d9ffa5ccf010fee954150dbb788fd9705234442e7d9f0ee5a42d3"
  revision 1
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "0c852cb4d55d672ce34333ef9446e710aa14906412bbe1dc4536d2f3ede3e404" => :catalina
    sha256 "06ccee1b64861c1ef08b4f5ee84827bd81daaa525b59c9135084f861b4a2ed3b" => :mojave
    sha256 "d2634d57c449aca834e3821bb1235b93d32e860eac182707b86d8798ea774653" => :high_sierra
    sha256 "c85d09436a79abfa41a10feeb717a65cf8ca44d08f08934f7dee79662573410b" => :x86_64_linux
  end

  def install
    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
    MachO::Tools.change_dylib_id("#{lib}/libre2.0.0.0.dylib", "#{lib}/libre2.0.dylib") if OS.mac?
    ext = OS.mac? ? "dylib" : "so"
    lib.install_symlink "libre2.0.0.0.#{ext}" => "libre2.0.#{ext}"
    lib.install_symlink "libre2.0.0.0.#{ext}" => "libre2.#{ext}"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11",
           "test.cpp", "-I#{include}", "-L#{lib}", "-pthread", "-lre2", "-o", "test"
    system "./test"
  end
end
