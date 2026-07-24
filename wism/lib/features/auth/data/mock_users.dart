import 'models/app_user.dart';

/// 개발용 사용자 시드 (WISM_seed_users.sql 와 동일). Mock 인증에서 사용.
const mockUsers = <AppUser>[
  AppUser(id: '1', employeeNo: '00000', name: '이태경', position: '대표이사', dept: 'CEO'),
  AppUser(id: '2', employeeNo: '00001', name: '이영호', position: '본부장', dept: '경영지원본부'),
  AppUser(id: '3', employeeNo: '00002', name: '이재철', position: '본부장', dept: '사업본부'),
  AppUser(id: '4', employeeNo: '00003', name: '이경우', position: '본부장', dept: '기획본부'),
  AppUser(id: '5', employeeNo: '00004', name: '엄세흔', position: '실장', dept: '사업 1실'),
  AppUser(id: '6', employeeNo: '00005', name: '백승선', position: '실장', dept: '사업 2실'),
  AppUser(id: '7', employeeNo: '00006', name: '이성근', position: '실장', dept: '사업 3실'),
  AppUser(id: '8', employeeNo: '00007', name: '박인근', position: '실장', dept: '사업 4실'),
  AppUser(id: '9', employeeNo: '00008', name: '이상화', position: '실장', dept: '사업 5실'),
  AppUser(id: '10', employeeNo: '00009', name: '최정민', position: '팀장', dept: '경영지원본부 지원팀'),
  AppUser(id: '11', employeeNo: '00010', name: '박정규', position: '팀장', dept: '사업 1실 1팀'),
  AppUser(id: '12', employeeNo: '00011', name: '황동기', position: '팀장', dept: '사업 1실 2팀'),
  AppUser(id: '13', employeeNo: '00012', name: '한성덕', position: '팀장', dept: '사업 2실 1팀'),
  AppUser(id: '14', employeeNo: '00013', name: '이영일', position: '팀장', dept: '사업 2실 2팀'),
  AppUser(id: '15', employeeNo: '00014', name: '윤병인', position: '팀장', dept: '사업 3실 1팀'),
  AppUser(id: '16', employeeNo: '00015', name: '배재현', position: '팀장', dept: '사업 3실 2팀'),
  AppUser(id: '17', employeeNo: '00016', name: '윤춘순', position: '팀장', dept: '사업 4실 1팀'),
  AppUser(id: '18', employeeNo: '00017', name: '채규철', position: '팀장', dept: '사업 4실 2팀'),
  AppUser(id: '19', employeeNo: '00018', name: '이주운', position: '팀장', dept: '사업 5실 1팀'),
  AppUser(id: '20', employeeNo: '00019', name: '강병욱', position: '팀장', dept: '사업 5실 2팀'),
  AppUser(id: '21', employeeNo: '00020', name: '김기남', position: '팀장', dept: '사업 5실 3팀'),
];

AppUser? findMockUser(String employeeNo) {
  for (final u in mockUsers) {
    if (u.employeeNo == employeeNo) return u;
  }
  return null;
}
