<%--
    Document   : add
    Created on : Mar 18, 2015, 11:02:49 AM
    Author     : ridvanayan
--%>
<%@page import="pu.web.modules.transfer.AdminTransferSellController"%>
<%@page import="pu.web.data.ROperations"%>
<%@page import="pu.web.modules.auth.RPuAuthorizationHelper"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@page import="pu.web.data.transfer.RMedia"%>
<%@page import="pu.web.config.RKeys"%>
<%@page import="pu.web.modules.accounting.RAccounting"%>
<%@page import="pu.web.modules.accounting.RAccountingCreditAccount"%>
<%@page import="pu.web.data.transfer.RRentACarSell"%>
<%@page import="pu.web.data.transfer.RRentACarSellStatus"%>
<%@page import="pu.web.modules.rentacar.RModelRentACarSell"%>
<%@page import="pu.web.data.transfer.RLocationPointArea"%>
<%@page import="pu.web.data.transfer.RLocationPointType"%>
<%@page import="pu.web.model.RModelLocationPoint"%>
<%@page import="pu.web.modules.accounting.RAccountingItemCategoryType"%>
<%@page import="pu.web.modules.accounting.RModelAccountingItemCategory"%>
<%@page import="pu.web.modules.accounting.RAccountingItemCategory"%>
<%@page import="pu.web.modules.customer.RCustomer"%>
<%@page import="pu.web.library.RPuLogHelper"%>
<%@page import="pu.web.data.transfer.RTransportationServicePricing"%>
<%@page import="pu.web.data.transfer.RTransportationServiceCustomerPricing"%>
<%@page import="pu.web.model.RModelTransportationCustomerPricing"%>
<%@page import="pu.web.data.transfer.RLocationPoint"%>
<%@page import="pu.web.data.RServiceType"%>
<%@page import="pu.web.model.RModelTransportationServicePricing"%>
<%@page import="pu.web.data.RPuCurrency"%>
<%@page import="pu.web.data.transfer.RPaymentMethod"%>
<%@page import="pu.web.config.RSettings"%>
<%@page import="pu.web.data.transfer.RVehicle"%>
<%@page import="pu.web.model.RModelVehiclePaymentReminder"%>
<%@page import="ra.library.helpers.RDateHelper"%>
<%@page import="pu.web.data.transfer.RVehicleEngineType"%>
<%@page import="pu.web.data.transfer.RVehicleTransmissionType"%>
<%@page import="pu.web.data.transfer.RVehicleModel"%>
<%@page import="pu.web.data.transfer.RVehicleType"%>
<%@page import="pu.web.model.RModelVehicle"%>
<%@page import="pu.web.data.transfer.RVehicleBrand"%>
<%@page import="pu.web.model.RModelVehicleModel"%>
<%@page import="pu.web.library.RPuAdminHtmlHelper"%>
<%@page import="pu.web.library.RPuHtmlHelper"%>
<%@page import="pu.web.core.RPuViewData"%>
<%@page import="pu.web.core.RWeb"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    RWeb web = new RWeb();
    RPuViewData view = RPuViewData.fromRequest(request);
    RModelRentACarSell model = (RModelRentACarSell) view.getModel();
    RRentACarSell object = (RRentACarSell) view.get("rentACarSell");

    RPuAdminHtmlHelper html = new RPuAdminHtmlHelper();
    String rootUrl = ((RModelRentACarSell) view.getModel()).getRootUrl();

    ArrayList<RRentACarSell> sells = new ArrayList<>();
    sells.add(object);
    for (Iterator<RRentACarSell> it = object.getCarChangeList().iterator(); it.hasNext();)
    {
        sells.add(it.next());
    }
%>

<c:set var="rentACarSell" value="${view.get('rentACarSell')}"></c:set>
<c:set var="DB_RENTACAR_SELL_STATUS_COMPLETED_BY_TAKEN" value="<%=RSettings.DB_RENTACAR_SELL_STATUS_COMPLETED_BY_TAKEN%>"></c:set>
<c:set var="totalPaid" value="${rentACarSell.getExtraPaymentPaidTotal()}"></c:set>
<c:set var="dept" value="${rentACarSell.totalPrice-totalPaid}"></c:set>

<%
    try
    {
%>
<div class="row">
    <div class="col-md-12">
        <div class="panel panel-yellow">
            <div class="panel-heading hidden-xs"><i class="fa fa-eye"></i> Kiralık Araç Sözleşme Detayları - Bilge Oto Kiralama</div>
            <div class="panel-heading visible-xs"><i class="fa fa-eye"></i> Kira Sözleşmesi</div>
            <div class="panel-body pan">
                <form name="formRentACarSell" class="disableInputs" action="<%= web.getUrlRelative(request, rootUrl + "/view/" + object.getId())%>" method="GET" >
                    <div class="form-actions pll prl">
                        <button type="button" class="btn btn-danger rMobileFullWidth" onclick="go('<%= web.getUrlRelative(request, rootUrl + "/list")%>')"><i class="fa fa-arrow-left"></i> Vazgeç</button>
                        &nbsp;
                        <button type="button" class="btn btn-blue rMobileFullWidth" onclick="printRentalAgreement()"><i class="fa fa-print"></i> Sözleşmeyi Yazdır</button>
                        &nbsp;
                        <button type="button" class="btn btn-blue rMobileFullWidth" onclick="printDiv('invoicePrintingDiv')"><i class="fa fa-print"></i> Fatura Yazdır</button>
                        &nbsp;
                        <button type="button" class="btn btn-info rMobileFullWidth" onclick="printDiv('emptyAgreementPrintingDiv')"><i class="fa fa-print"></i> Boş Sözleşme Yazdır</button>
                        &nbsp;
                        <button type="button" class="btn btn-blue rMobileFullWidth" onclick="printDiv('agreementReturnPrintingDiv')"><i class="fa fa-print"></i> Teslim Tutanağını Yazdır</button>
                        &nbsp;
                        <%if (model.getRights().hasUpdateRight())
                            {%>
                        <button type="button" class="btn btn-green rMobileFullWidth" onclick="go('<%= web.getUrlRelative(request, rootUrl + "/update/" + object.getId())%>')">Güncelle <i class="fa fa-arrow-right"></i></button>
                            <%}%>
                    </div>

                    <div class="form-body pal">
                        <c:if test="${rentACarSell.isCancelled()}">
                            <div class="row">
                                <div class="col-md-12" style="font-size: x-large">
                                    ${html.getErrorBox('BU SÖZLEŞME İPTAL EDİLMİŞTİR !')}
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${rentACarSell.isCustomerForbidden()}">
                            <div class="row">
                                <div class="col-md-12" style="font-size: x-large">
                                    ${html.getErrorBox('BU MÜŞTERİ KARA LİSTEDEDİR !')}
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${rentACarSell.carChangeList !=null && fn:length(rentACarSell.carChangeList)>0}">
                            <div class="row">
                                <div class="col-md-12" style="font-size: large">
                                    ${html.getInfoBox('Bu sözleşmede araç değişimi yapılmıştır!')}
                                </div>
                            </div>
                        </c:if>
                        <div class="row">
                            <%= html.getSuccessBox(view.getSuccess())%>
                            <%= html.getWarningBox(view.getWarning())%>
                            <%= html.getErrorBox(view.getError())%>
                        </div>
                        <div class="row">
                            <div class="col-md-12">

                                <div class="row">
                                    <div class="col-md-12">

                                        <h3><i class="fa fa-user-secret"></i> Kayıt Bilgileri</h3>
                                        <div class="row">
                                            <div class="col-md-3 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="recordedByUserId" class="control-label">Kaydeden Yetkili <span class="require">*</span></label>
                                                    <select name="recordedByUserId" id="recordedByUserId" class="form-control" required>
                                                        <option value="">${rentACarSell.authUser != null && !rentACarSell.authUser.secret? rentACarSell.authUser.createRepresentativeName(true):''}</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="col-md-3 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="" class="control-label">Kayıt Tarihi <span class="require">*</span></label>
                                                    <div class="input-icon">
                                                        <i class="fa fa-clock-o"></i><input name="" id="" type="text" value="<%= new RDateHelper(object.getRecordDate()).getDayMonthYearHourMinuteSecond()%>" placeholder="" class="form-control datetimepicker-default">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-3 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="" class="control-label">Son Güncelleme Tarihi <span class="require">*</span></label>
                                                    <div class="input-icon">
                                                        <i class="fa fa-clock-o"></i><input name="" id="" type="text" value="<%= new RDateHelper(object.getLastUpdateDate()).getDayMonthYearHourMinuteSecond()%>" placeholder="" class="form-control datetimepicker-default">
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="col-md-3 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="recordedByUserId" class="control-label">İade Alan Yetkili <span class="require">*</span></label>
                                                    <select name="recordedByUserId" id="recordedByUserId" class="form-control" required>
                                                        <option value="">${rentACarSell.authUserTakenBackBy != null && !rentACarSell.authUserTakenBackBy.secret? rentACarSell.authUserTakenBackBy.createRepresentativeName(true):''}</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-12 col-sm-12 col-xs-12">
                                                <div class="form-group">
                                                    <label for="takenBackNotes" class="control-label">Geri İade Notu</label>
                                                    <input type="text" name="takenBackNotes" id="takenBackNotes" value="${rentACarSell.takenBackNotes}" class="form-control">
                                                </div>
                                            </div>

                                        </div>

                                        <h3 class="hidden-xs"><i class="fa fa-user"></i> Kimlik Bilgileri</h3>
                                        <h3 class="visible-xs"><i class="fa fa-user"></i> Müşteri</h3>
                                        <div class="row">
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iAgreementCustomerFullname" class="control-label">Ad Soyad</label> <span class="require">(*)</span>
                                                    <input type="text" name="iAgreementCustomerFullname" id="iAgreementCustomerFullname" value="${rentACarSell.customerFullname}" class="form-control">
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iAgreementCustomerIdentifierNo" class="control-label">Kimlik No</label>
                                                    <input type="text" name="iAgreementCustomerIdentifierNo" id="iAgreementCustomerIdentifierNo" value="${rentACarSell.customerIdentifierNo}" class="form-control">
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iAgreementCustomerPassportNo" class="control-label">Pasaport No</label>
                                                    <input type="text" name="iAgreementCustomerPassportNo" id="iAgreementCustomerPassportNo" value="${rentACarSell.customerPassportNo}" class="form-control">
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iAgreementCustomerDrivingLisenceNo" class="control-label">Ehliyet No</label> <span class="require">(*)</span>
                                                    <input type="text" name="iAgreementCustomerDrivingLisenceNo" id="iAgreementCustomerDrivingLisenceNo" value="<%= object.getCustomerDrivingLisenceNo()%>" class="form-control">
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iAgreementCustomerDateOfBirth" class="control-label hidden-xs">Doğum Tarihi</label> <span class="require hidden-xs">(*)</span>
                                                    <label for="iAgreementCustomerDateOfBirth" class="control-label visible-xs">Doğum Trh.<span class="require">*</span></label>
                                                    <input type="text" name="iAgreementCustomerDateOfBirth" id="iAgreementCustomerDateOfBirth" value="${rentACarSell.getCustomerDateOfBirth()}" class="form-control datepicker-default" autocomplete="off">
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iAgreementCustomerBloodType" class="control-label">Kan Gr.</label>
                                                    <select name="iAgreementCustomerBloodType" id="iAgreementCustomerBloodType" class="form-control">
                                                        <option></option>
                                                        <%= html.getBloodTypeSelectOptions(object.getCustomerBloodType())%>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iAgreementCustomerMotherName" class="control-label">Ana Adı</label>
                                                    <input type="text" name="iAgreementCustomerMotherName" id="iAgreementCustomerMotherName" value="<%= object.getCustomerMotherName()%>" class="form-control">
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iAgreementCustomerFatherName" class="control-label">Baba Adı</label>
                                                    <input type="text" name="iAgreementCustomerFatherName" id="iAgreementCustomerFatherName" value="<%= object.getCustomerFatherName()%>" class="form-control">
                                                </div>
                                            </div>

                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iAgreementCustomerBirthPlace" class="control-label">Doğum Yeri</label>
                                                    <div class="input-icon">
                                                        <i class="fa fa-edit"></i><input name="iAgreementCustomerBirthPlace" id="iAgreementCustomerBirthPlace" type="text" value="<%= object.getAgreementCustomerBirthPlace()%>" placeholder="" class="form-control" autocomplete="off">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iAgreementCustomerNationality" class="control-label">Uyruk</label>
                                                    <div class="input-icon">
                                                        <i class="fa fa-edit"></i><input name="iAgreementCustomerNationality" id="iAgreementCustomerNationality" type="text" value="<%= object.getAgreementCustomerNationality()%>" placeholder="" class="form-control" autocomplete="off">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iAgreementCustomerDrivingLisenceDeliveryLocation" class="control-label">Ehliyet Veriliş Yer</label>
                                                    <div class="input-icon">
                                                        <i class="fa fa-edit"></i><input name="iAgreementCustomerDrivingLisenceDeliveryLocation" id="iAgreementCustomerDrivingLisenceDeliveryLocation" type="text" value="<%= object.getAgreementCustomerDrivingLisenceDeliveryLocation()%>" placeholder="" class="form-control" autocomplete="off">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iAgreementDocumentNo" class="control-label hidden-xs">Sözleşme Num.</label><%= html.getTextIf(model.isAgreementDocumentNoRequired(), true, "<span class=\"require hidden-xs\">(*)</span>")%>
                                                    <label for="iAgreementDocumentNo" class="control-label visible-xs">Sözleşme No <%= html.getTextIf(model.isAgreementDocumentNoRequired(), true, "<span class=\"require\">(*)</span>")%></label>
                                                    <input type="text" name="iAgreementDocumentNo" id="iAgreementDocumentNo" value="<%= object.getAgreementDocumentNo()%>" class="form-control">
                                                </div>
                                            </div>

                                        </div>

                                        <h3 class="visible-xs"><i class="fa fa-phone"></i> İletişim</h3>
                                        <h3 class="hidden-xs"><i class="fa fa-phone"></i> İletişim Bilgileri</h3>
                                        <div class="row">

                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iCustomerPhonePersonalGsm1" class="control-label">Cep Telefonu 1<span class="require">*</span></label>
                                                    <div class="input-icon">
                                                        <i class="fa fa-edit"></i><input name="iCustomerPhonePersonalGsm1" id="iCustomerPhonePersonalGsm1" type="text" value="<%= object.getCustomerPhonePersonalGsm1()%>" placeholder="" class="form-control" required="">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iCustomerPhonePersonalGsm2" class="control-label">Cep Telefonu 2</label>
                                                    <div class="input-icon">
                                                        <i class="fa fa-edit"></i><input name="iCustomerPhonePersonalGsm2" id="iCustomerPhonePersonalGsm2" type="text" value="<%= object.getCustomerPhonePersonalGsm2()%>" placeholder="" class="form-control">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iCustomerPhoneBusiness" class="control-label">İş Telefonu</label>
                                                    <div class="input-icon">
                                                        <i class="fa fa-edit"></i><input name="iCustomerPhoneBusiness" id="iCustomerPhoneBusiness" type="text" value="<%= object.getCustomerPhoneBusiness()%>" placeholder="" class="form-control">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iCustomerPhoneBusinessGsm" class="control-label">İş Cep Telefonu</label>
                                                    <div class="input-icon">
                                                        <i class="fa fa-edit"></i><input name="iCustomerPhoneBusinessGsm" id="telGsm2" type="text" value="<%= object.getCustomerPhoneBusinessGsm()%>" placeholder="" class="form-control">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iCustomerPhoneHome" class="control-label">Ev Telefonu</label>
                                                    <div class="input-icon">
                                                        <i class="fa fa-edit"></i><input name="iCustomerPhoneHome" id="iCustomerPhoneHome" type="text" value="<%= object.getCustomerPhoneHome()%>" placeholder="" class="form-control">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iAgreementCustomerEmail" class="control-label">E-posta</label>
                                                    <input type="text" name="iAgreementCustomerEmail" id="iAgreementCustomerEmail" value="${rentACarSell.customerEmail}" class="form-control">
                                                </div>
                                            </div>

                                            <div class="col-md-4 col-sm-6 col-xs-12">
                                                <div class="form-group">
                                                    <label for="iAgreementCustomerAddress" class="control-label">Ev Adresi</label>
                                                    <textarea rows="2" name="iAgreementCustomerAddress" id="iAgreementCustomerAddress" class="form-control">${rentACarSell.customerAddress}</textarea>
                                                </div>
                                            </div>
                                            <div class="col-md-4 col-sm-6 col-xs-12">
                                                <div class="form-group">
                                                    <label for="iAgreementCustomerLocalAddress" class="control-label">Yerel Adresi</label>
                                                    <textarea rows="2" name="iAgreementCustomerLocalAddress" id="iAgreementCustomerLocalAddress" class="form-control">${rentACarSell.customerLocalAddress}</textarea>
                                                </div>
                                            </div>
                                            <div class="col-md-4 col-sm-6 col-xs-12">
                                                <div class="form-group">
                                                    <label for="iAgreementCustomerWorkAddress" class="control-label">İş Adresi</label>
                                                    <textarea rows="2" name="iAgreementCustomerWorkAddress" id="iAgreementCustomerWorkAddress" class="form-control"><%= object.getCustomerWorkAddress()%></textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-12">
                                        <h3 class="hidden-xs"><i class="fa fa-users"></i> Aracı Kullanacak Ek Kişiler</h3>
                                        <h3 class="visible-xs"><i class="fa fa-users"></i> Ek Şöförler</h3>
                                        <%
                                            int driverCount = object.getExtraDriverCount();
                                            for (int i = 0; i < driverCount; i++)
                                            {
                                        %>
                                        <div class="row">
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iExtraDriverFullname[<%=i%>]" class="control-label">Ad Soyad</label>
                                                    <input type="text" name="iExtraDriverFullname[<%=i%>]" id="iExtraDriverFullname[<%=i%>]" value="<%=  html.getFormDataInArray(object.getExtraDriverFullname(), i)%>" class="form-control">
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iExtraDriverIdentifierNo[<%=i%>]" class="control-label">Kimlik / Pas. No</label>
                                                    <input type="text" name="iExtraDriverIdentifierNo[<%=i%>]" id="iExtraDriverIdentifierNo[<%=i%>]" value="<%= html.getFormDataInArray(object.getExtraDriverIdentifierNo(), i)%>" class="form-control">
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iExtraDriverDrivingLisenceNo[<%=i%>]" class="control-label">Ehliyet No</label>
                                                    <input type="text" name="iExtraDriverDrivingLisenceNo[<%=i%>]" id="iExtraDriverDrivingLisenceNo[<%=i%>]" value="<%= html.getFormDataInArray(object.getExtraDriverDrivingLisenceNo(), i)%>" class="form-control">
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iExtraDriverPhone[<%=i%>]" class="control-label">Telefon</label>
                                                    <input type="text" name="iExtraDriverPhone[<%=i%>]" id="iExtraDriverPhone[<%=i%>]" value="<%= html.getFormDataInArray(object.getExtraDriverPhone(), i)%>" class="form-control">
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iExtraDriverDateOfBirth[<%=i%>]" class="control-label">Doğum T.</label>
                                                    <input type="text" name="iExtraDriverDateOfBirth[<%=i%>]" id="iExtraDriverDateOfBirth[<%=i%>]" value="<%= html.getFormDataInArray(object.getExtraDriverDateOfBirth(), i)%>" class="form-control datepicker-default" autocomplete="off">
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iExtraDriverBloodType[<%=i%>]" class="control-label">Kan Gr.</label>
                                                    <select name="iExtraDriverBloodType[<%=i%>]" id="iExtraDriverBloodType[<%=i%>]" class="form-control">
                                                        <option></option>
                                                        <%= html.getBloodTypeSelectOptions(html.getFormDataInArray(object.getExtraDriverBloodType(), i))%>
                                                    </select>

                                                </div>
                                            </div>
                                        </div>
                                        <%= html.getTextIf(i, driverCount - 1, "", "<hr style=\"border-style: dashed;\">")%>
                                        <%
                                            }
                                        %>
                                    </div>
                                </div>

                                <div class="row section">
                                    <div class="col-md-12">
                                        <h3><i class="fa fa-car"></i> Araç Bilgileri</h3>
                                        <div class="row">
                                            <div class="col-md-4 col-sm-4 col-xs-12">
                                                <div class="form-group">
                                                    <label for="iVehicleId" class="control-label">Araç</label> <span class="require">(*)</span>
                                                    <select name="iVehicleId" id="iVehicleId" class="form-control">
                                                        <option></option>
                                                        <%
                                                            for (RVehicle item : (ArrayList<RVehicle>) view.get("vehicleList"))
                                                            {
                                                        %>
                                                        <option value="<%= item.getId()%>" <%= html.getSelectedIf(object.getVehicle().getId(), item.getId())%>><%= item.getLisencePlate() + " - " + item.getModel().getRepresentativeFullName(true)%></option>
                                                        <%
                                                            }
                                                        %>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-4 col-sm-6 col-xs-12">
                                                <div class="form-group">
                                                    <label for="iPickUpDateTime" class="control-label">Veriliş Tarihi ve Saati</label> <span class="require">(*)</span>
                                                    <input type="text" name="iPickUpDateTime" id="iPickUpDateTime" value="<%= new RDateHelper(object.getPickUpDateTime()).setDelim(".", ":").getDayMonthYearHourMinute()%>" class="form-control datetimepicker-default" autocomplete="off">
                                                </div>
                                            </div>
                                            <div class="col-md-4 col-sm-6 col-xs-12">
                                                <div class="form-group">
                                                    <label for="iDropOffDateTime" class="control-label">Geri Dönüş Tarihi ve Saati</label> <span class="require">(*)</span>
                                                    <input type="text" name="iDropOffDateTime" id="iDropOffDateTime" value="<%= new RDateHelper(object.getDropoffDateTime()).setDelim(".", ":").getDayMonthYearHourMinute()%>" class="form-control datetimepicker-default" autocomplete="off">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 col-sm-6 col-xs-6">
                                                <div class="form-group">
                                                    <label for="pickUpLocationId" class="control-label">Veriliş Noktası<span class="require">*</span></label>
                                                    <select name="pickUpLocationId" id="pickUpLocationId" class="form-control">
                                                        <option></option>
                                                        <c:forEach var="item" items="${view.get('locationList')}">
                                                            <option value="${item.id}" ${rentACarSell.pickUpLocation.id == item.id ? 'selected':''}>${item.name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-6 col-sm-6 col-xs-6">
                                                <div class="form-group">
                                                    <label for="returnLocationId" class="control-label">Geri İade Noktası<span class="require">*</span></label>
                                                    <select name="returnLocationId" id="returnLocationId" class="form-control">
                                                        <option></option>
                                                        <c:forEach var="item" items="${view.get('locationList')}">
                                                            <option value="${item.id}" ${rentACarSell.returnLocation.id == item.id ? 'selected':''}>${item.name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 col-sm-6 col-xs-12">
                                                <div class="form-group">
                                                    <label for="iPickUpAddress" class="control-label">Araç Veriliş Adresi</label> <span class="require">(*)</span>
                                                    <textarea rows="2" name="iPickUpAddress" id="iPickUpAddress" class="form-control"><%= object.getPickupAddress()%></textarea>
                                                </div>
                                            </div>
                                            <div class="col-md-6 col-sm-6 col-xs-12">
                                                <div class="form-group">
                                                    <label for="iDropOffAddress" class="control-label">Araç Geri Dönüş Adresi</label> <span class="require">(*)</span>
                                                    <textarea rows="2" name="iDropOffAddress" id="iDropOffAddress" class="form-control"><%= object.getDropoffAddress()%></textarea>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-2 col-sm-12 col-xs-12">
                                                <div class="form-group">
                                                    <label for="iEarlyReturnDateTime" class="control-label">Erken Teslim Tarihi</label>
                                                    <%
                                                        String earlyReturnDate = object.getEarlyReturnDate();
                                                        if (earlyReturnDate == null || earlyReturnDate.isEmpty())
                                                        {
                                                            earlyReturnDate = "";
                                                        }
                                                        else
                                                        {
                                                            earlyReturnDate = new RDateHelper(earlyReturnDate).setDelim(".", ":").getDayMonthYearHourMinute();
                                                        }
                                                    %>
                                                    <input type="text" name="iEarlyReturnDateTime" id="iEarlyReturnDateTime" value="<%= earlyReturnDate%>" class="form-control datetimepicker-default" autocomplete="off">
                                                </div>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-xs-12">
                                                <div class="form-group">
                                                    <label for="iOilExisting" class="control-label">Benzin Miktarı</label>
                                                    <input type="text" name="iOilExisting" id="iOilExisting" value="<%= html.getTextIfNotNull(object.getOil())%>" class="form-control">
                                                </div>
                                            </div>

                                            <div class="col-md-2 col-sm-4 col-xs-12">
                                                <div class="form-group">
                                                    <label for="iOutKm" class="control-label">Veriliş Km.</label>
                                                    <input type="text" name="iOutKm" id="iOutKm" value="<%= html.getTextIfNotNull(object.getOutKm())%>" class="form-control">
                                                </div>
                                            </div>

                                            <div class="col-md-2 col-sm-4 col-xs-12">
                                                <div class="form-group">
                                                    <label for="iInKm" class="control-label">Dönüş Km.</label>
                                                    <input type="text" name="iInKm" id="iInKm" value="<%= html.getTextIfNotNull(object.getInKm())%>" class="form-control">
                                                </div>
                                            </div>

                                            <div class="col-md-2 col-sm-12 col-xs-12">
                                                <div class="form-group">
                                                    <label for="iStatusId" class="control-label">Sözleşme Durumu</label>
                                                    <select name="iStatusId" id="iStatusId" class="form-control">
                                                        <option></option>
                                                        <%
                                                            for (RRentACarSellStatus item : (ArrayList<RRentACarSellStatus>) view.get("statusList"))
                                                            {
                                                        %>
                                                        <option value="<%= item.getId()%>" <%= html.getSelectedIf(object.getStatus().getId(), item.getId())%>><%= item.getName()%></option>
                                                        <%
                                                            }
                                                        %>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="col-md-2 col-sm-12 col-xs-6">
                                                <div class="form-group">
                                                    <label for="limitKm" class="control-label">Km Sınırı</label>
                                                    <div class="input-icon">
                                                        <i class="fa fa-road"></i>
                                                        <input type="number" name="limitKm" id="limitKm" value="${rentACarSell.limitKm}" class="form-control" min="0" step="10">
                                                    </div>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>

                                <c:if test="${rentACarSell.carChangeList !=null && fn:length(rentACarSell.carChangeList)>0}">
                                    <div class="row section">
                                        <div class="col-md-12">
                                            <h3><i class="fa fa-exchange"></i> Araç Değişim Kayıtları</h3>
                                            <div class="row hidden-xs">
                                                <div class="col-md-3 col-sm-6 col-xs-12">
                                                    <div class="form-group">
                                                        <label for="iRecordDate2" class="control-label">Değişim Tarihi</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-3 col-sm-6 col-xs-12">
                                                    <div class="form-group">
                                                        <label for="iVehicleId2" class="control-label">Önceki Araç</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-4 col-sm-6 col-xs-12">
                                                    <div class="form-group">
                                                        <label for="iPickUpDateTime2" class="control-label">Sözleşme Tarihleri</label>
                                                    </div>
                                                </div>
                                                <div class="col-md-2 col-sm-6 col-xs-12">
                                                    <div class="form-group">
                                                        <label for="iRecordDate2" class="control-label">&nbsp;</label>
                                                    </div>
                                                </div>
                                            </div>

                                            <%
                                                int carChangeCounter = 0;
                                                for (RRentACarSell sellPrevious : sells)
                                                {
                                            %>
                                            <div class="row <%= sellPrevious.getId() == object.getId() ? "currentSell " : ""%> <%= carChangeCounter == 0 ? "activeSell " : ""%>">
                                                <div class="col-md-3 col-sm-6 col-xs-12">
                                                    <div class="form-group">
                                                        <label for="iRecordDate2" class="control-label visible-xs">Değişim Tarihi</label>
                                                        <input type="text" id="iRecordDate2" value="<%= new RDateHelper(sellPrevious.getRecordDate()).setDelim(".", ":").getDayMonthYearHourMinuteSecond()%>" class="form-control" autocomplete="off" readonly data-toggle="tooltip" title="<%= object.getAuthUserTakenBackBy() != null ? object.getAuthUserTakenBackBy().createRepresentativeName(true) : ""%> tarafından <%= object.getBranch().getName()%> şubesine kaydedilmiştir." >
                                                        <!--
                                                        <div class="input-icon">
                                                        <%= sellPrevious.getId() == object.getId() ? "<i class=\"fa fa-check\"></i>" : ""%>
                                                        <input type="text" id="iRecordDate2" value="<%= new RDateHelper(sellPrevious.getRecordDate()).setDelim(".", ":").getDayMonthYearHourMinuteSecond()%>" class="form-control" autocomplete="off" readonly>
                                                    </div>
                                                        -->
                                                    </div>
                                                </div>
                                                <div class="col-md-3 col-sm-6 col-xs-12">
                                                    <div class="form-group">
                                                        <label for="iVehicleId2" class="control-label visible-xs">Önceki Araç</label>
                                                        <input type="text" class="form-control" value="<%= sellPrevious.getVehicle().getLisencePlate() + " - " + sellPrevious.getVehicle().getModel().getRepresentativeFullName(true)%>" readonly data-toggle="tooltip" title="<%= object.getAuthUserTakenBackBy() != null ? object.getAuthUserTakenBackBy().createRepresentativeName(true) : ""%> tarafından <%= object.getBranch().getName()%> şubesine kaydedilmiştir.">
                                                    </div>
                                                </div>
                                                <div class="col-md-4 col-sm-6 col-xs-12">
                                                    <div class="form-group">
                                                        <label for="iPickUpDateTime2" class="control-label visible-xs">Sözleşme Tarihleri</label>
                                                        <input type="text" id="iPickUpDateTime2" value="<%= new RDateHelper(sellPrevious.getPickUpDateTime()).setDelim(".", ":").getDayMonthYearHourMinute()%> -- <%= new RDateHelper(sellPrevious.findDropOffDateTime()).setDelim(".", ":").getDayMonthYearHourMinute()%>" class="form-control " autocomplete="off" readonly data-hover="tooltip" title="<%= object.getAuthUserTakenBackBy() != null ? object.getAuthUserTakenBackBy().createRepresentativeName(true) : ""%> tarafından <%= object.getBranch().getName()%> şubesine kaydedilmiştir.">
                                                    </div>
                                                </div>
                                                <div class="col-md-2 col-sm-6 col-xs-12">
                                                    <div class="form-group">
                                                        <!--<label for="iRecordDate2" class="control-label">&nbsp;</label>-->
                                                        <%if (sellPrevious.getId() == object.getId())
                                                            {%>
                                                        <!--<button type="button" class="form-control btn btn-green" style="color:white; cursor: default"><i class="fa fa-check"></i> Etkin Sözleşme</button>-->
                                                        <!--<span class="label label-green bigLabel">Etkin Sözleşme</span>-->
                                                        <%}
                                                        else
                                                        {%>
                                                        <a href="<%= web.getUrlRelative(request, model.getRootUri() + "/view/" + sellPrevious.getId())%>" target="_blank" ><button type="button" class="form-control btn btn-blue" style="color:white;" data-toggle="tooltip" title="<%= object.getAuthUserTakenBackBy() != null ? object.getAuthUserTakenBackBy().createRepresentativeName(true) : ""%> tarafından <%= object.getBranch().getName()%> şubesine kaydedilmiştir."><i class="fa fa-eye"></i> İncele</button></a>
                                                        <%}%>
                                                    </div>
                                                </div>
                                            </div>
                                            <%
                                                    carChangeCounter++;
                                                }
                                            %>
                                        </div>
                                    </div>
                                </c:if>

                                <div class="row section">
                                    <div class="col-md-12">
                                        <h3 class=""><i class="fa fa-plus"></i> Ek Bilgiler</h3>

                                        <div class="row">
                                            <div class="col-md-12">
                                                <h4><i class="fa fa-list-ul"></i> Ek Hizmetler</h4>
                                                <div class="row">
                                                    <div class="col-md-10">
                                                        <div class="row">
                                                            <c:set var="dayCount" value="${rentACarSell.calculateDayDifference()}"></c:set>

                                                            <c:forEach var="extra" items="${rentACarSell.getExtraList()}">
                                                                <c:set var="extraItemCount" value="${rentACarSell.getExtraMap().get(extra.getId())}"></c:set>
                                                                <div class="col-xs-4" data-hover="tooltip" title="${extra.getDescription()}">
                                                                    <span class="hidden-sm">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>${extra.iconCss != null && !extra.iconCss.isEmpty() ? extra.iconCss : '<img src="${contextPath}${extra.imgPath}" width="20px" />'}&nbsp;${extra.name} x ${dayCount} gün
                                                                </div>

                                                                <div class="col-xs-4">
                                                                    <strong style="font-size: 13px">${html.getMoney(extra.currency, extra.price)} / günlük</strong> (Toplam ${html.getMoney(extra.currency, extra.getDailyPrice()*rentACarSell.calculateDayDifference())})
                                                                </div>

                                                                <c:choose>
                                                                    <c:when test="${extra.maxCount == 1}">
                                                                        <div class="col-xs-4">
                                                                            <input style="width:16px; height:16px" type="checkbox" name="extras[${extra.id}]" id="extras[${extra.id}]" value="1" ${extraItemCount>0?'checked':''}>
                                                                            <label for="extras[${extra.id}]" style="cursor: pointer">Evet</label>
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="col-xs-4">
                                                                            x
                                                                            <select name="extras[${extra.id}]" id="extras[${extra.id}]" class="form-control" style="display: initial; width:50%;" data-item-count="${rentACarSell.getExtraMap().get(extra.getId())}" data-map="${rentACarSell.getExtraMap()}">
                                                                                <c:forEach begin="0" end="${extra.maxCount}" var="value">
                                                                                    <option value="${value}" ${value == extraItemCount ?'selected':''}>${value}</option>
                                                                                </c:forEach>
                                                                            </select>
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>

                                                                <div class="col-xs-12">
                                                                    <hr class="" style="border-top:1px dashed; margin-top:2px; margin-bottom:2px;">
                                                                </div>

                                                            </c:forEach>

                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row mtl">
                                            <div class="col-md-12 col-xs-12">
                                                <div class="form-group">
                                                    <label for="iCustomerComments" class="control-label">Müşteri Yorumu</label>
                                                    <textarea rows="3" name="iCustomerComments" id="iCustomerComments" class="form-control"><%= object.getCustomerComments()%></textarea>
                                                </div>
                                            </div>
                                            <div class="col-md-12 col-xs-12">
                                                <div class="form-group">
                                                    <label for="iSystemNotes" class="control-label">Sistem Notu</label>
                                                    <textarea rows="3" name="iSystemNotes" id="iSystemNotes" class="form-control"><%= object.getSystemNotes()%></textarea>
                                                </div>
                                            </div>
                                        </div>

                                        <%if (RSettings.CONFIG.getRentACarShowFileUploadOnAgreement())
                                            {%>
                                        <div class="row">
                                            <div class="col-xs-12">
                                                <label>Sözleşme Evrakları (Görsel)</label>
                                            </div>

                                            <div class="col-xs-12">
                                                <div class="row">
                                                    <div class="col-xs-12">
                                                        <div class="row">
                                                            <%
                                                                int imgCounter = 0;
                                                                for (RMedia m : object.getCustomerMediaList())
                                                                {
                                                            %>
                                                            <div class="col-xs-1" id="existingImgPreviewId<%=imgCounter%>">
                                                                <a href="<%= web.getAsset(request, m.getUri())%>" title="Dosyayı Göster" target="_blank"><img id="existingImgInputId<%=imgCounter%>" src="<%= web.getAsset(request, m.getUri())%>" width="54" height="42" /></a>

                                                                <input type="hidden" id="ixExistingImgUriList<%=imgCounter%>" name="ixExistingImgUriList[<%=imgCounter%>]" value="<%= m.getUri()%>">
                                                            </div>
                                                            <%
                                                                    imgCounter++;
                                                                }
                                                            %>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>
                                        <%}%>
                                    </div>
                                </div>


                                <!-- TRANSFER BİLGİLERi -->
                                <% if (object.getTransferSell() != null && RSettings.CONFIG.getBackendShowTransferInRentACarAgreement() && RPuAuthorizationHelper.hasRight(request, ROperations.TRANSPORTATION_TRANSFER_WORK_VIEW)){ %>
                                <div class="row section">
                                    <div class="col-md-12">
                                        <h3>
                                            <input style="width:25px; height:25px" type="checkbox" class="cbHasTransfer" name="cbHasTransfer" id="cbHasTransfer" value="${empty rentACarSell.getTransferSell()?'0':1}" ${rentACarSell.getTransferSell()!=null ?'checked triggerchange':''} >
                                            <label for="cbHasTransfer" style="cursor: pointer">Transfer Detayları <i class="fa fa-taxi"></i></label>
                                        </h3>
                                    </div>
                                    <div class="col-md-12">
                                        <h4>Müşterinin transferi de var - <a target="_blank" href="${contextPath}<%= AdminTransferSellController.CONTROLLER_BASE_URI %>/view/${rentACarSell.getTransferSell().getId()}">transfer detaylarını görüntüle</a></h4>
                                    </div>
                                </div>
                                <%}%>

                                <%
                                    Boolean accountingExists;
                                    Boolean commissionAccountingExists;
                                    if (object.getAccounting() == null || object.getAccounting().getId() == null)
                                    {
                                        accountingExists = false;
                                    }
                                    else
                                    {
                                        accountingExists = true;
                                    }

                                    if (object.getCommissionAccounting() == null || object.getCommissionAccounting().getId() == null)
                                    {
                                        commissionAccountingExists = false;
                                    }
                                    else
                                    {
                                        commissionAccountingExists = true;
                                    }
                                %>

                                <div class="row">
                                    <div class="col-md-12">
                                        <h3 class="thinBorderBottom"><i class="fa fa-credit-card"></i> Ödeme Bilgileri</h3>
                                        <%if (accountingExists && commissionAccountingExists && !(object.getAccounting().getAmount() + object.getCommissionAccounting().getAmount() == object.getTotalPrice()))
                                            {%>
                                        <%= html.getWarningBox("Muhasebe kayıtlarında görünen bu satıştan aracı ücreti hariç kasaya giren  tutar (<span class=\"rBold\">" + (object.getAccounting().getAmount()) + "</span>) ile sözleşmeye göre aracı ücreti hariç net tutarı (<span class=\"rBold\">" + (object.getTotalPrice() - object.getSellerCommissionAmount()) + "</span>) farklıdır. Muhasebe fatura tutarı veya satış sözleşme kaydı değiştirilmiş olabilir. Dilerseniz ilgili muhasebe kaydını <a class=\"rUnderline\" href=\"" + web.getUrlRelative(request, "admin/accounting/general/view/" + object.getAccounting().getId()) + "\"> buraya tıklayarak</a> gözden geçirebilirsiniz.")%>
                                        <%}%>

                                        <c:if test="${rentACarSell.hasExtraPaymentAccountingPaid()}">
                                            <c:forEach var="item" items="${rentACarSell.getExtraPaymentAccountingPaidList()}">
                                                <c:set var="text" value='<a target="_blank" data-hover="tooltip" title="Detaylı göster" href="${contextPath}admin/accounting/general/view/${item.id}"> <span class="bold">${dh.setDateWithMysqlDate(item.recordDate).setDelim(".",":").getDayMonthYearHourMinuteSecond()}</span> tarihinde <span class="bold">${item.paymentMethod.name}</span> ödeme yolu ile <span class="bold">${html.getMoneyBeautiful(item.currency, item.amount)}</span> alınmıştır.</a>'></c:set>
                                                ${html.getSuccessBox(text)}
                                            </c:forEach>
                                        </c:if>
                                        <c:set var="desc" value="<span style=\"color:black\">Toplam ücret: ${html.getMoneyBeautiful(rentACarSell.currency,rentACarSell.totalPrice)}</span> | <span style=\"color:green\"><i class=\"fa fa-check\"></i>Toplam ödenen: ${html.getMoneyBeautiful(rentACarSell.currency,totalPaid)}</span> | <span style=\"color:red\">Kalan Bakiye: ${html.getMoneyBeautiful( rentACarSell.currency,(rentACarSell.totalPrice-totalPaid) )}</span>"></c:set>
                                        ${html.getInfoBox(desc)}

                                        <div class="row">
                                            <div class="col-md-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iTotalPrice" class="control-label">Toplam Ücret</label>${view.getModel().isSellPriceRequired()?'<span class="require">(*)</span>':''}
                                                    <input type="text" name="iTotalPrice" id="iTotalPrice" value="${rentACarSell.getTotalPrice()}" class="form-control" autocomplete="off" >
                                                </div>
                                            </div>
                                            <div class="col-md-4 col-xs-6">
                                                <div class="form-group">
                                                    <label for="iCurrencyId" class="control-label">Para Birimi${view.getModel().isSellPriceRequired()?'<span class="require">(*)</span>':''}</label>
                                                    <select name="iCurrencyId" id="iPaymentMethodId" class="form-control">
                                                        <option></option>
                                                        <c:forEach var="item" items="${view.get('currencyList')}">
                                                        <option value="${item.getId()}" ${item.getId()==rentACarSell.getCurrency().getId()?'selected':''}>${item.getName()}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="col-md-4 col-xs-12">
                                                <div class="form-group">
                                                    <label for="branchId" class="control-label">Şube</label>
                                                    <select name="branchId" id="branchId" class="form-control">
                                                        <option value=""></option>
                                                        <c:forEach var="item" items="${view.get('branchList')}">
                                                            <option value="${item.getId()}" ${rentACarSell.getBranch().getId()==item.getId()?"selected":""}>${item.getName()}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>

                                <%
                                    if (model.isAccountingActive())
                                    {
                                        Integer paymentMethodId = null;
                                        String invoiceNo = "";

                                        if (object.getAccounting() != null)
                                        {
                                            RAccounting acc = object.getAccounting();
                                            paymentMethodId = acc.getPaymentMethod().getId();
                                            invoiceNo = acc.getInvoiceNo();
                                        }
                                        if (commissionAccountingExists && !object.getCommissionAccounting().getAmount().equals(object.getSellerCommissionAmount()))
                                {%>
                                <%=html.getWarningBox("Muhasebe kayıtlarında görünen aracılık tutarı (<span class=\"rBold\">" + object.getCommissionAccounting().getAmount() + "</span>) ile sözleşmede yazan aracılık tutarı (<span class=\"rBold\">" + object.getSellerCommissionAmount() + "</span>) farklıdır. Muhasebe fatura tutarı veya satış sözleşme kaydı değiştirilmiş olabilir. Dilerseniz ilgili muhasebe kaydını <a class=\"rUnderline\" href=\"" + web.getUrlRelative(request, "admin/accounting/general/view/" + object.getCommissionAccounting().getId()) + "\"> buraya tıklayarak</a> gözden geçirebilirsiniz.")%>
                                <%}%>

                                <div class="row">
                                    <div class="col-md-6 col-xs-6">
                                        <div class="form-group">
                                            <label for="iSellerCommissionAmount" class="control-label">Aracı Ücreti</label>
                                            <input type="text" name="iSellerCommissionAmount" id="iSellerCommissionAmount" value="<%= html.getTextIfNotNull(object.getSellerCommissionAmount())%>" class="form-control" autocomplete="off">
                                        </div>
                                    </div>
                                    <div class="col-md-6 col-xs-6">
                                        <div class="form-group">
                                            <label for="iSellerCreditAccountId" class="control-label">Aracı Hesabı</label>
                                            <select name="iSellerCreditAccountId" id="iSellerCreditAccountId" class="form-control">
                                                <option></option>
                                                <%
                                                    for (RAccountingCreditAccount item : (ArrayList<RAccountingCreditAccount>) view.get("creditAccountList"))
                                                    {
                                                        Integer commissionCreditAccountId;
                                                        if (object.getCommissionAccounting() != null)
                                                        {
                                                            commissionCreditAccountId = object.getCommissionAccounting().getCreditAccountId();
                                                        }
                                                        else
                                                        {
                                                            commissionCreditAccountId = null;
                                                        }
                                                        if (item.isCustomerLike())
                                                        {
%>
                                                <option value="<%= item.getId()%>" <%= html.getSelectedIf(commissionCreditAccountId, item.getId())%>><%= item.getName()%></option>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <%if (!accountingExists)
                                    {%>
                                <%--<%= // html.getInfoBox("Muhasebe kaydı için ödeme şekli bölümünü mutlaka doldurmalısınız.")%>--%>
                                <%}%>

                                <div class="row">
                                    <div class="col-md-6 col-xs-6">
                                        <div class="form-group">
                                            <label for="iPaymentMethodId" class="control-label">Ödeme Şekli</label>
                                            <select name="iPaymentMethodId" id="iPaymentMethodId" class="form-control">
                                                <option></option>
                                                <%
                                                    for (RPaymentMethod item : (ArrayList<RPaymentMethod>) view.get("paymentMethodList"))
                                                    {
%>
                                                <option value="<%= item.getId()%>" <%= html.getSelectedIf(paymentMethodId, item.getId())%>><%=item.getName()%></option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6 col-xs-6">
                                        <div class="form-group">
                                            <label for="iInvoiceNo" class="control-label">Fatura No</label>
                                            <input type="text" name="iInvoiceNo" id="iInvoiceNo" value="<%= html.getTextIfNotNull(invoiceNo)%>" class="form-control" autocomplete="off">
                                        </div>
                                    </div>
                                </div>
                                <%
                                    }
                                %>

                                <c:if test="${view.getModel().isAccountingActive()}">
                                    <!-- PAYMENT DETAILS BLOCK START !-->
                                    <c:set var="iCreditAccountId" value="${rentACarSell.getAccounting().getCreditAccountId()}" scope="request"></c:set>
                                    <c:set var="createAutoCreditAccountIfCustomerIsNew" value="${view.getModel().isCreateAutoCreditAccountIfCustomerIsNew()?'1':''}" scope="request"></c:set>
                                    <c:set var="iChequeNo" value="${rentACarSell.getAccounting().getChequeNo()}" scope="request"></c:set>
                                    <c:set var="iChequeOwnerName" value="${rentACarSell.getAccounting().getChequeOwnerName()}" scope="request"></c:set>
                                    <c:set var="iChequeEncashmentDate" value="${rentACarSell.getAccounting().getChequeEncashmentDate()}" scope="request"></c:set>
                                    <c:set var="iChequeOwnedDate" value="${rentACarSell.getAccounting().getChequeOwnedDate()}" scope="request"></c:set>
                                    <c:set var="iCreditCardBankCommission" value="${rentACarSell.getAccounting().getCreditCardBankCommission()}" scope="request"></c:set>
                                    <c:set var="iCreditCardOwnerNameSurname" value="${rentACarSell.getAccounting().getCreditCardOwnerNameSurname()}" scope="request"></c:set>
                                    <jsp:include page="../../../../../../view/${language}/accounting/_shared/payment_method_components.jsp"/>
                                    <!-- //PAYMENT DETAILS BLOCK END !-->
                                </c:if>

                            </div>
                        </div>
                    </div>

                    <div class="form-actions pll prl">
                        <button type="button" class="btn btn-danger rMobileFullWidth" onclick="go('<%= web.getUrlRelative(request, rootUrl + "/list")%>')"><i class="fa fa-arrow-left"></i> Vazgeç</button>
                        &nbsp;
                        <button type="button" class="btn btn-blue rMobileFullWidth" onclick="printRentalAgreement()"><i class="fa fa-print"></i> Sözleşmeyi Yazdır</button>
                        &nbsp;
                        <button type="button" class="btn btn-blue rMobileFullWidth" onclick="printDiv('invoicePrintingDiv')"><i class="fa fa-print"></i> Fatura Yazdır</button>
                        &nbsp;
                        <button type="button" class="btn btn-info rMobileFullWidth" onclick="printDiv('emptyAgreementPrintingDiv')"><i class="fa fa-print"></i> Boş Sözleşme Yazdır</button>
                        &nbsp;
                        <button type="button" class="btn btn-blue rMobileFullWidth" onclick="printDiv('agreementReturnPrintingDiv')"><i class="fa fa-print"></i> Teslim Tutanağını Yazdır</button>
                        &nbsp;
                        <%if (model.getRights().hasUpdateRight())
                            {%>
                        <button type="button" class="btn btn-green rMobileFullWidth" onclick="go('<%= web.getUrlRelative(request, rootUrl + "/update/" + object.getId())%>')">Güncelle <i class="fa fa-arrow-right"></i></button>
                            <%}%>
                    </div>

                    <input type="hidden" name="iId" value="<%= object.getId()%>"/>
                    <input type="hidden" name="ixAgreementAuthorizedUserId" value="${rentACarSell.getAuthUser().getId()}"/>

                    <%
                        /*demekki muhasebe kaydı var*/
                        if (accountingExists)
                        {%>
                    <input type="hidden" name="ixAccountingId" value="<%= object.getAccounting().getId()%>"/>
                    <!--<input type="text" name="iTotalPrice" value="<%= object.getTotalPrice()%>">-->
                    <%}%>

                    <%
                        /*demekki muhasebe kaydı var*/
                        if (commissionAccountingExists)
                        {%>
                    <input type="hidden" name="ixCommissionAccountingId" value="<%= object.getCommissionAccounting().getId()%>"/>
                    <%}%>

                </form>
            </div>
        </div>
    </div>
</div>

<div class="hidden" id="invoicePrintingDiv">
    <%= object.getInvoiceTemplateHtml()%>
</div>
<div class="hidden" id="emptyAgreementPrintingDiv">
    <%= object.getEmptyTemplateHtml()%>
</div>
<div class="hidden" id="agreementPrintingDiv">
    <%= object.getPrintingTemplateHtml()%>
</div>

<div class="hidden" id="agreementReturnPrintingDiv">
    <%= object.getPrintingTemplateReturnReport()%>
</div>

<%
    }
    catch (Exception ex)
    {
        new RPuLogHelper().logException(ex, rootUrl + "/update.jsp");
            }
%>
<script>
    function printAgreement()
    {
        print('<%=object.getPrintingTemplateHtml()%>');
    }
    function printAgreementEmpty()
    {
        print('<%= object.getEmptyTemplateHtml()%>');
    }
</script>

<script>
    function printAgreementPage1()
    {
        print5('<%= object.getPrintingTemplateHtmlPage1()%>');
    }

    function printAgreementPage2()
    {
        print5('<%= object.getPrintingTemplateHtmlPage2()%>');
    }

    function print5(html)
    {
        var newWindow = window.open();
        newWindow.document.body.innerHTML = html;
        newWindow.document.close();
        newWindow.focus();

        setTimeout(function () {
            newWindow.print();
            newWindow.close();
        }, 500);
    }

    function print1(data)
    {
        alert("print1");
        var mywindow = window.open('', 'Araç Kiralama Sözleşmesiv', 'height=400,width=600');
        mywindow.document.write(data);
        mywindow.document.close(); /* necessary for IE >= 10*/
        mywindow.focus(); /* necessary for IE >= 10*/
        mywindow.print();
        mywindow.close();
        return true;
    }

    function print2(elementId)
    {
        alert("print2");
        var newWindow = window.open();
        newWindow.document.write(document.getElementById(elementId).innerHTML);
        newWindow.print();
        newWindow.close();
    }

    function print3(html)
    {
        alert("print3");
        var restorepage = document.body.innerHTML;
        var printcontent = html;
        document.body.innerHTML = printcontent;
        window.print();
        document.body.innerHTML = restorepage;
    }

    function print4(html)
    {
        alert("print4");
        var newWindow = window.open();
        newWindow.document.write(html);
        newWindow.print();
        newWindow.close();
    }
</script>

<!-- JS DYNAMIC PRINT -->
<script>
    function printRentalAgreement()
    {
        /*see object on browser console to see dynamic data should be replaced on html*/
        var myVar1, object, rentTime, returnTime, printHtml;
        object = ${rentACarSell};
        rentTime = '<%= new RDateHelper(object.getPickUpDateTime()).setDelim(".", ":").getDayMonthYearHourMinute()%>';
        returnTime = '<%= new RDateHelper(object.getDropoffDateTime()).setDelim(".", ":").getDayMonthYearHourMinute()%>'
        rentTime = rentTime.substring(11);
        returnTime = returnTime.substring(11);
            printHtml = '<!doctype html><html class="no-js" lang=""> <head> <meta charset="utf-8"> <meta http-equiv="x-ua-compatible" content="ie=edge"> <title>Page 1</title> <meta name="description" content=""> <meta name="viewport" content="width=device-width, initial-scale=1"> <link rel="manifest" href="site.webmanifest"> <link rel="apple-touch-icon" href="<![CDATA[CONTEXTPATH]]>admin/components/bilgerentacar_print/icon.png"><style>th{text-align:left}hr,p,ul{margin-bottom:1rem}html{box-sizing:border-box;font-family:sans-serif;line-height:1.15;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;-ms-overflow-style:scrollbar;-webkit-tap-highlight-color:transparent}*,::after,::before{box-sizing:inherit}@-ms-viewport{width:device-width}article,aside,footer,header,main,nav,section{display:block}body{margin:0;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif;font-size:1rem;font-weight:400;line-height:1.5;color:#212529;background-color:#fff}p,ul{margin-top:0}.container,.container-fluid{margin-right:auto;margin-left:auto;width:100%;padding-right:15px;padding-left:15px}img{vertical-align:middle;border-style:none}table{border-collapse:collapse}h1,h2,h3,h4,h5,h6{margin-top:0;margin-bottom: .5rem;font-family:inherit;font-weight:500;line-height:1.1;color:inherit}h1{font-size:2.5rem}h2{font-size:2rem}h3{font-size:1.75rem}h4{font-size:1.5rem}h5{font-size:1.25rem}h6{font-size:1rem}hr{box-sizing:content-box;height:0;overflow:visible;margin-top:1rem;border:0;border-top:1px solid rgba(0,0,0,.1)}.mt-0{margin-top:0!important}.mb-0{margin-bottom:0!important}.row{display:-ms-flexbox;display:flex;-ms-flex-wrap:wrap;flex-wrap:wrap;margin-right:-15px;margin-left:-15px}.col-md-1,.col-md-2,.col-md-3,.col-md-4,.col-md-5,.col-md-6{position:relative;width:100%;min-height:1px;padding-right:15px;padding-left:15px}.border{border:1px solid #e9ecef!important}.d-flex{display:-ms-flexbox!important;display:flex!important}.flex-row{-ms-flex-direction:row!important;flex-direction:row!important}.flex-column{-ms-flex-direction:column!important;flex-direction:column!important}.justify-content-between{-ms-flex-pack:justify!important;justify-content:space-between!important}.ml-2{margin-left: .5rem!important}.ml-3{margin-left:1rem!important}.mt-3{margin-top:1rem!important}.ml-4{margin-left:1.5rem!important}.mt-4{margin-top:1.5rem!important}.ml-5{margin-left:3rem!important}.mt-5{margin-top:3rem!important}.pt-4{padding-top:1.5rem!important}.pl-5{padding-left:3rem!important}.pt-5{padding-top:3rem!important}.text-justify{text-align:justify!important}.text-left{text-align:left!important}.text-right{text-align:right!important}.text-center{text-align:center!important}@media print{#subTab1,#subTab2,#subTab3,#subTab4{height:210px}#mainTab,.borderBottom{border-bottom:1px solid #000}#mainTab,.borderLeft{border-left:1px solid #000}#mainTab{width:1000px}table tr td{padding-top:0;padding-bottom:0}#subTab1{width:170px}.subTab11Row1 td:nth-child(2), .subTab11Row2 td:nth-child(2), .subTab11Row3 td:nth-child(2){width:27px}.width-30{column-span:25}#subTab2{width:310px}#subTab3{width:110px}.mainTabBodyRow3Col4 table{width:200px}#subTab10,#subTab8,#subTab9{width:500px}#subTab11,#subTab5{width:350px}#subTab10,#subTab11,.logo{height:70px}#subTab6{width:80px}.subTab6Row1 td{padding:0 10px}.subTab6Row1 td:nth-child(3){padding:0 9px}#subTab6 tr td{width:50px}#subTab7{width:250px}.mainTabBodyRow4 tr td{width:200px}.mainTabBodyRow3 tr td{width:250px}.borderRight{border-right:1px solid #000}.borderBottomDotted{border-bottom:1px dotted #000}.borderTop{border-top:1px solid #000}.name{height:30px;margin-left:70px}.formImage{height:340px}.flexItem1{margin-right:5px}.flexItem2{margin-left:50px}.flexItem3{position:absolute;margin-left:830px}.flexItem3>div:first-child div{margin-left:35px}.flexItem3>div:last-child{margin-right:7px}hr{border-color:#000}.separator1{margin-top:0}.polisSpan{padding-left:80px}.trafikSpan{padding-left:70px}.jandarmaSpan{padding-left:40px}.mb-0{margin-bottom:0!important}.leftSignature{margin-left:80px}.rightSignature{margin-right:80px}.setFontSize{font-size:11px}.padLeft{padding-left:16px}#thirdPage{margin-top:730px}#mainContent{visibility:hidden}@media print{body{margin-top:0}#mainContent{visibility:visible}}.firstBorder{position:absolute;margin-left:615px;margin-top:47px;border-right:1px solid #000;height:340px}.secondBorder,.thirdBorder{position:absolute;margin-top:177px;border-right:1px solid #000}.secondBorder,.thirdBorder{border-right:1px solid #000}.secondBorder{margin-left:785px;margin-top:224px;height:360px}.thirdBorder{margin-left:915px;margin-top:224px;height:163px}#secondPageMarginTop{margin-top:60px}.donus{padding-left:100px}}.Cikis{padding-left:50px}.fourthBorder{position:absolute;border-right:1px solid #000;margin-left:830px;margin-top:135px;height:32px}</style></head> <body> <div id="mainOne" class="container-fluid mt-0"> <div class="container" id="mainContent"> <div class="row"> <div class="row"> <div class="container-fluid mb-0"> <div class="row d-flex flex-row justify-content-between"> <div class="pt-5 flexItem1"> <img class="logo" src="<![CDATA[CONTEXTPATH]]>admin/components/bilgerentacar_print/img/bilge-logo.png"> <div class=""> <h4 class="mb-0"><span>www.billgeotokiralama.com</span></h4> <h4 class="mb-0"><span>info@bilgeotokiralama.com</span></h4> </div></div><div class="pt-5 flexItem2"> <div class="text-center pt-4"> <h3 class="mb-0"><span>UZUN DÖNEM</span></h3> <h3 class="mb-0"><span>OTO KİRALAMA SÖZLEŞMESI</span></h3> <h3 class="mb-0"><span>N °</span> <span>000601</span></h3> </div></div><div class="flexItem3 mt-4"> <div class="text-left"> <div> <span class="">TRAFİK </span> <span class="trafikSpan"> : 154</span><br><span class="">POLİS </span> <span class="polisSpan"> : 155</span><br><span class="">JANDARMA </span> <span class="jandarmaSpan"> : 156</span> </div></div> <img src="<![CDATA[CONTEXTPATH]]>admin/components/bilgerentacar_print/img/name.png" class="name"> <div class="text-right"> <h6 class="mb-0"><span>15 Mayıs Mah. Atatürk Cad.</span></h6> <h6 class="mb-0"><span>No. 26 DENİZLİ</span></h6> <h6 class="mb-0"><span>Tel. : 0 546 261 66 44</span></h6> <h6 class="mb-0"><span>0 258 261 66 44</span></h6> </div></div></div></div></div><div class="row"><div class="firstBorder">&nbsp;</div><div class="secondBorder">&nbsp;</div><div class="thirdBorder">&nbsp;</div><div class="fourthBorder">&nbsp;</div> <table id="mainTab" class=""><thead></thead><tbody id="mainTabBody"><tr class="mainTabBodyRow1"><th colspan="3" class="borderRight borderTop text-center">Kiralayanin</th><th colspan="3">&nbsp;</th><th colspan="12">&nbsp;</th></tr><tr class="mainTabBodyRow2 borderTop borderBottom borderRight"><td colspan="3" class="borderRight">T.C. Kimlik No:</td><td colspan="3" class="borderRight text-center">'+ '<strong style="font-size: 13px">' + '${rentACarSell.customerIdentifierNo}'+ '</strong>' +'</td><td colspan="12" class="borderRight">Kiralanan Otonun</td></tr><tr class="mainTabBodyRow3"><td colspan="3" class="borderRight"><table id="subTab1"><tr class="borderBottomDotted"><td>Pasaport No:</td></tr><tr class="borderBottomDotted"><td>Vergi No:</td></tr><tr class="borderBottomDotted"><td>Adi Soyadi</td></tr><tr class="borderBottomDotted"><td>Baba-Ana Adi</td></tr><tr><td>DogumYeri ve Tarihi</td></tr></table></td><td colspan="3" class="borderRight"><table id="subTab2"><tr class="borderBottomDotted"><td class="text-center">'+ '<strong style="font-size: 13px">' + '${rentACarSell.customerPassportNo}'+ '</strong>' +'</td></tr><tr class="borderBottomDotted"><td>&nbsp;</td></tr><tr class="borderBottomDotted"><td class="text-center">'+ '<strong style="font-size: 13px">' + '${rentACarSell.customerFullname}'+ '</strong>' +'</td></tr><tr class="borderBottomDotted"><td class="text-center">'+ '<strong style="font-size: 13px">' + '${rentACarSell.customerFatherName}' + ' - ' + '${rentACarSell.customerMotherName}' + '</strong>' + '</td></tr><tr class=""><td class="text-center">'+ '<strong style="font-size: 13px">' + '${rentACarSell.customerDateOfBirth}' + ' '+ '<%= object.getAgreementCustomerBirthPlace()%>' + '</strong>' +'</td></tr></table></td><td colspan="3" class=""><table id="subTab3"><tr><td>Markasi:</td></tr><tr><td>Modeli:</td></tr><tr><td>Plaka No.:</td></tr><tr class="borderBottom"><td>&nbsp;</td></tr><tr class="borderBottom"><td style="padding: 12px 0px">Benzin Durumu</td></tr><tr><td>&nbsp;</td></tr></table></td><td colspan="9" class="borderRight mainTabBodyRow3Col4"><table id="subTab4"><tr class="borderBottomDotted setwidth"><td colspan="6" class="text-center">' + '<strong style="font-size: 13px">' + object.vehicle.model.name + '</strong>' + '</td></tr><tr class="borderBottomDotted"><td colspan="6" class="text-center">'+ '<strong style="font-size: 13px">' + object.vehicle.model.brand.name + '</strong>' + '</td></tr><tr class="borderBottomDotted"><td colspan="6" class="text-center">'+ '<strong style="font-size: 13px">' + object.vehicle.lisencePlate + '</strong>' +'</td></tr><tr class="borderBottom"><td colspan="6"><table id="subTab5"><tr><td colspan="3" class="Cikis">Cikis</td><td colspan="3" class="donus">Donus</td></tr></table></td></tr><tr class=""><td colspan="2" class=""><table id="subTab6" class="text-center"><tr class="borderBottom subTab6Row1"><td class="borderRight subTab6Row1Col1">1/4</td><td class="borderRight subTab6Row1Col2">2/4</td><td class="borderRight subTab6Row1Col3">3/4</td><td class="borderRight subTab6Row1Col1">4/4</td></tr><tr class="subTab6Row2"><td class="borderRight subTab6Row2Col1"></td><td class="borderRight subTab6Row2Col2">&nbsp;</td><td class="borderRight subTab6Row2Col3">&nbsp;</td><td class="borderRight subTab6Row2Col4">&nbsp;</td></tr></table></td><td colspan="3"><table id="subTab7" class="text-center"><tr class="borderBottom subTab7Row1"><td class="borderRight subTab7Row1Col1">1/4</td><td class="borderRight subTab7Row1Col1">2/4</td><td class="borderRight subTab7Row1Col1">3/4</td><td>4/4</td></tr><tr><td class="borderRight">&nbsp;</td><td class="borderRight">&nbsp;</td><td class="borderRight">&nbsp;</td><td>&nbsp;</td></tr></table></td></tr><tr class="borderTop text-center"><td colspan="2" class="">Tarih</td><td colspan="2" class="">Saat</td><td colspan="2" class="">Km.</td></tr></table></td></tr><tr class="mainTabBodyRow4 borderTop borderBottom borderRight"><td colspan="6" class="borderRight">Nufusa Kayitli Oldugu:</td><td colspan="3" class="text-center">Cikis</td><td colspan="3" class="">'+ '<span class="pl-5">' +'<strong style="font-size: 13px">' + '<%= new RDateHelper(object.getPickUpDateTime()).setDelim(".", ":").getDayMonthYear()%>'+ '</strong>'+ '</span>' + '</td><td colspan="3" class="">' + '<div style="position: absolute; margin-left: -190px; margin-top: -8px">' +'<strong style="font-size: 13px">' + rentTime + '</strong>' + '</div>' +'</td><td colspan="3" class="">'+ '<div style="position: absolute; margin-left: -75px; margin-top: -8px">' + '<strong style="font-size: 13px">' + '<%= html.getTextIfNotNull(object.getOutKm())%>'+ '</strong>'+ '</div>' +'</td></tr><tr class="mainTabBodyRow5 borderRight"><td colspan="6" class=""><table id="subTab8"><tr class="borderBottom text-center"><td class="borderRight">Il</td><td class="borderRight">Ilçe</td><td>Mahalle-Köy</td></tr><tr class="borderBottom"><td class="borderRight">&nbsp;</td><td class="borderRight">&nbsp;</td><td>&nbsp;</td></tr><tr class="borderBottom text-center"><td class="borderRight">Cilt No.</td><td class="borderRight">Aile Sira No.</td><td>Sira No.</td></tr><tr class="borderBottom"><td class="borderRight">&nbsp;</td><td class="borderRight">&nbsp;</td><td>&nbsp;</td></tr><tr class="borderBottom text-center"><td colspan="6">Nufus Cuzdan No.</td></tr><tr class="borderBottom text-center"><td class="borderRight">Verildugi Yer</td><td class="borderRight">Verildigi Tarih</td><td>Kayit No.</td></tr><tr class="borderBottom text-center"><td class="borderRight">&nbsp;</td><td class="borderRight">&nbsp;</td><td>&nbsp;</td></tr><tr class="borderBottom"><td colspan="6">1. Surucunun Belgesinin</td></tr><tr class="borderBottom text-center"><td class="borderRight">Verildugi Yer</td><td class="borderRight">Verildigi Tarih</td><td>Kayit No.</td></tr><tr class="borderBottom"><td class="borderRight">&nbsp;</td><td class="borderRight">&nbsp;</td><td>&nbsp;</td></tr><tr class="borderBottom"><td colspan="6">2. Surucunun Belgesinin</td></tr><tr class="borderBottom text-center"><td class="borderRight">Verildugi Yer</td><td class="borderRight">Verildigi Tarih</td><td>Kayit No.</td></tr><tr class="borderBottom"><td class="borderRight">&nbsp;</td><td class="borderRight">&nbsp;</td><td>&nbsp;</td></tr><tr class="borderBottom"><td colspan="6"><table id="subTab9" border="0" width="250"><tr class="borderBottomDotted"><td>Adres Ev : '+ '<strong style="font-size: 13px">' +'${rentACarSell.customerAddress}'+ '</strong>' +'</td></tr><tr class="borderBottomDotted"><td>&nbsp;</td></tr><tr class="borderBottomDotted"><td>Adres Is : ' + '<strong style="font-size: 13px">' + '<%= object.getCustomerWorkAddress()%>'+ '</strong>' +'</td></tr><tr><td>&nbsp;</td></tr></table></td></tr><tr><td colspan="6"><table id="subTab10"><tr class="borderBottomDotted"><td class="borderRight" style="width: 50px">Tel Ev : '+ '<strong style="font-size: 13px">' + '<%= object.getCustomerPhoneHome()%>'+ '</strong>' +'</td><td style="width: 50px">Tel Is : '+ '<strong style="font-size: 13px">' + '<%= object.getCustomerPhoneBusiness()%>'+ '</strong>' +'</td></tr><tr class=""><td class="borderRight" style="width: 50px">Gsm : '+ '<strong style="font-size: 13px">' +'<%= object.getCustomerPhonePersonalGsm1()%>'+ '</strong>' +'</td><td style="width: 50px">Fax : </td></tr></table></td></tr></table></td><td colspan="12" class="borderLeft mainTabBodyRow4Col2"><table id="subTab11"><tr class="borderBottom subTab11Row1"><td style="max-width: 15px;" colspan="4" class="text-center"><span>Planlanan</span><br><span>Dönüs</span></td><td colspan="4">' + '<div style="position: absolute; margin-left: 55px; margin-top: -8px">' + '<strong style="font-size: 13px">' + '<%= new RDateHelper(object.getDropoffDateTime()).setDelim(".", ":").getDayMonthYear()%>'+ '</strong>' + '</div>' +'</td><td style="padding-left: 30px" colspan="4" class="text-center">'+ '<div style="position: absolute; margin-left: 18px; margin-top: -8px">' +'<strong style="font-size: 13px">' + '<strong style="font-size: 13px">' + returnTime + '</strong>' + '</div>' +'</td><td style="max-width: 20px" colspan="4" class="">'+ '<div style="position: absolute; margin-left: -65px; margin-top: -8px">' + '<strong style="font-size: 13px">' + '&nbsp;' + '</strong>' + '</div>' +'</td></tr><tr class="borderBottom subTab11Row2"><td style="max-width: 10px" colspan="4" class="text-center">Dönüs</td><td style="max-width: 20px" colspan="4" class="">&nbsp;</td><td style="max-width: 0px" colspan="4" class="">&nbsp;</td><td style="max-width: 0px" colspan="4">&nbsp;</td></tr><tr class="borderBottom subTab11Row3"><td style="max-width: 10px" colspan="4" class="">Kiralama Suresi</td><td style="max-width: 0px" colspan="4" class="text-center">'+ '<strong style="font-size: 13px">' + '<%= object.calculateDayDifference() %>'+ '</strong>' +'</td><td style="padding-left: 30px" colspan="4" class="">Ek Süre</td><td style="max-width: 0px" colspan="4">&nbsp;</td></tr><tr class="borderBottom"><td style="min-width: 150px" colspan="8" class="">Kiralama Ucreti</td><td colspan="8">&nbsp;</td></tr><tr class="borderBottom"><td colspan="8" class="">Teslim Alma, Tek Yön Ücreti</td><td colspan="8">&nbsp;</td></tr><tr class="borderBottom"><td colspan="8"class="">Aracin Teslim Adresi</td><td colspan="8">&nbsp;</td></tr><tr class="borderBottom"><td colspan="8" class="">Servis ve Diger Ücretler</td><td colspan="8">&nbsp;</td></tr><tr class="borderBottom"><td colspan="8" class=""><span>Kiraci Hasar Muafiyetini</span><br><span>Asagidaki Ucretleri Kabul veya</span><br><span>Red Eder</span></td><td colspan="8"><span>Kiraci Ferdi Kaza Sigortasini</span><br><span>Asagidaki Ucretleri Kabul veya</span><br><span>Red Eder</span></td></tr><tr class="borderBottom"><td colspan="8" class=""><table id="subTab12" style="min-width: 290px"><tr class="borderBottom"><td colspan="" class="borderRight">Günlük</td><td>&nbsp;</td></tr><tr class="text-center"><td class="borderRight">Red</td><td>Kabul</td></tr></table></td><td colspan="8"><table id="subTab13" style="width: 240px"><tr class="borderBottom"><td class="borderRight">Günlük</td><td>&nbsp;</td></tr><tr class="text-center"><td class="borderRight">Red</td><td>Kabul</td></tr></table></td></tr><tr class="borderBottom"><td colspan="16"><span>KREDI KARTI BILGILERI</span><br><span>&nbsp;</span><br><span>&nbsp;</span><br></td></tr><tr><td colspan="8"><span>KIRALAYAN</span><br><span>Adı Soyadı: '+ '<strong style="font-size: 13px">'  
                    /*+ '${rentACarSell.customerFullname}'*/
                    + '&nbsp;'
                    + '</strong>' 
                    +'</span><br><span>Kiralama Tarihi: '
                    + '<strong style="font-size: 13px">' 
                    /*+ '<%= new RDateHelper(object.getPickUpDateTime()).setDelim(".", ":").getDayMonthYearHourMinute()%>' */
                    + '&nbsp;'
                    + '</strong>' 
                    + '</span><br><span>Imza:</span></td><td colspan="8"><span>KEFIL</span><br><span>Adi Soyadi:</span><br><span>Kiralama Tarihi: '+ '<strong style="font-size: 13px">' +'<%= new RDateHelper(object.getPickUpDateTime()).setDelim(".", ":").getDayMonthYearHourMinute()%>'+ '</strong>' + '</span><br><span>Imza:</span></td></tr></table></td></tr></tbody><tfoot></tfoot></table> </div><div class="row"> <div class="container"> <div class="text-justify"> <p class="paragraph1 padParagraph mb-0"> <span>1- <b>Bilge Rent A Car</b> \'dan kiralamış olduğum aracın; bakım sorumluluğu tarafıma ait olmak, kendi hesabıma trafik kurallarına uygun olarak</span><br><span>kullanmak ve tehlikesi bana ait olmak üzere kiraladım. Sözleşmenin ön ve arka sayfalarında belirtilen şartları okuyup kabul ettim.</span> </p><p class="paragraph2 padParagraph mb-0"> <span>2- Kiralamış olduğum aracın kaza veya yanlış kullanımdan dolayı işten kalma bedelini ve trafik para cezalarını ödemeyi taahhüt ederim.</span><br></p><p class="paragraph3 padParagraph mb-0"> <span>3-Lastik, Cant, tampon, ayna, far ve camlardaki hasarlar kasko sigortasına dahil değildir. 3000 TL. ye kadar olan küçük hasarlar kasko sigortası</span><br><span>kapsamına girmez ve kiralayan hasar\' kendi öder.</span> </p><p class="paragraph4 padParagraph"> <span>4-Kiracı,ölümlü yada yaralanmalı kazaya karışırsa, sorumluluk kiracı ve kefiline aittir. Kan parası veya başka tazminatları ödemekle kendisi</span><br><span> yükümlüdür. şahıslara ve çevreye verdiği zarar ve hasarların tamamından kiracı sorumludur. <b>BİLGE RENT A CAR\'</b> dan herhangi bir hak talep edilemez. Tamamen kendi sorumluluğundadır.</span> </p></div></div></div><div class="row"> <div class="container"> <div class="row d-flex flex-row justify-content-between"> <div class=""> <img src="<![CDATA[CONTEXTPATH]]>admin/components/bilgerentacar_print/img/form.png" class="formImage"> </div><div class=""> <div class="ml-4 mb-0 d-flex flex-row justify-content-between"> <div class="flexItemForm1"> <span>Vade</span> <hr class="separator1"> <hr class="separator2"> </div><div class="flexItemForm2"> <span>Ödeme Günü</span> <hr class="mt-0"> <hr class=""> </div><div class="flexItemForm3"> <span>Türk Lirası</span> <hr class="mt-0"> <hr class=""> </div><div class="flexItemForm4"> <span>Kuruş</span> <hr class="mt-0"> <hr class=""> </div><div class="flexItemForm5"> <span>No.</span> <hr class="mt-0"> <hr class=""> </div></div><div class="ml-3 " style="max-width: 850px"> <span>iş bu emre yazılı senedim........................mukabilinde..............................................................................................................................tarihinde</span><br><span>Sayın....................................................................................................................................................................................veya emruhavale....................</span><br><span>Yukarıdayazılı yalnız........................................................................................................................................................................................Türk Lirası</span><br><span>..................................................Kuruş kayıtsız şartsız ödeyeceği...................Bedeli..............................................ahzolunmuştur. İş bu emre</span><br><span>yazılı senet vadesinde ödenmediği taktirde müteakip bonolarında muacceliyet kesbedeceğini Avukat ücreti dahil Mahkeme masraflarını ödeyeceğimi...................İhtilaf vukuunda.........................................................................................................................</span><br><span>Mahkemelerinin selahiyetini şimdiden kabul eyleri..................</span> </div><div class="ml-3 d-flex flex-row justify-content-between para3" style="max-width: 850px"> <div class=""> <span>Isim / Ünvan :......................................................................................................................</span><br><span>Ödeme Yeri :........................................................................................................................</span><br><span>V.D.:No.su T.C.Kimlik No :..............................................................................................</span><br><span>Kefil :......................................................................................................................................</span><br><span>V.D.:No.su T.C.Kimlik No :..............................................................................................</span> </div><div class="d-flex flex-column justify-content-between"> <div> <span>Düzenleme Tarih:.............../............../20.................</span><br><span>Düzenleme Yeri :........................................................</span> </div><div class="d-flex flex-row justify-content-between"> <div class="text-left"> <span>İmza</span> </div><div class="text-right"> <span>İmza</span> </div></div></div></div></div></div></div></div></div></div><div class="container" style="margin-top:100px"> <div class="row"> <div class="container mt-5"> <h4 class="text-center mainTitle"><span class="borderBottom">ARİYET SÖZLEŞMESİ</span></h4> <section class="row mt-5"> <div class="container"> <h6 class="">MADDE 1 – TARAFLAR</h6> <div class="ml-5"> <span>.........../...........Adresinde ikamet eden ........... İLE ......... ....../........... adresinde ikamet </span><br><span>eden ........ ....... Arasında aşağıdaki koşullarla bir ariyet sözleşmesi akdolunmuştur.</span> </div><div class="ml-5"> <span>İş bu sözleşmede ;</span><br><span>.......... ........ \'ariyet veren\',</span><br><span>......... .......... \'ariyet alan\' olarak anılacaktır.</span> </div></div></section> <section class="row mt-3"> <div class="container"> <h6 class="">MADDE 2 – KONU ;</h6> <div class="ml-5"> <span>İş bu sözleşmenin konusu, mülkiyeti ariyet verene ait olan .............. plakalı aracın ................. gün</span><br><span>süresiyle ariyet alana, kullanma amacıyla bedelsiz olarak verilmesidir.</span> </div></div></section> <section class="row mt-3"> <div class="container"> <h6 class="">MADDE 3 – TARAFLARIN YÜKÜMLÜLÜKLERİ ;</h6> <div class="ml-5"> <span>-Ariyet veren, ariyet konusu, ................... Plakalı aracı ..................... tarihinde ariyet alana </span> <span class="padLeft">teslim edilecektir.</span><br><span>-Ariyet alan, ariyet konusu aracı her türlü dikkat ve özeni göstererek kullanacak, kesinlikle üçüncü </span> <span class="padLeft">kişilere kullandırmayacaktır.</span><br><span>-Ariyet konusu aracın güncel kilometresi ........... km olup ariyet alan en fazla 150 km </span> <span class="padLeft">yol yapma hakkına sahiptir. Bunu aşan kullanımlar için her km başına ............. TL ücret </span> <span class="padLeft">ödemekle yükümlü olacak.</span><br><span>-Ariyet alan ariyet konusu aracı .......... tarihinde iade edecek olup, sözleşme süresinin </span> <span class="padLeft">bitiminde iade etmediği takdirde gecikilen her gün için ......... Türk Lirası ödeyecektir.</span><br><span>-Ariyet alan ariyet konusu araca gelecek her türlü zarardan sorumlu olacaktır. Ariyet </span> <span class="padLeft">konusunun kullanılmayacak derecede zarar görmesi durumunda, ariyet verenin </span> <span class="padLeft">yaptıracağı ekspertiz raporuna binaen aracın rayiç bedelini ariyet verene </span> <span class="padLeft">ödeyecektir.</span><br><span>-2918 sayılı Karayolları Trafik Kanunu m.3 uyarınca sözleşme süresince işleten sıfatı </span> <span class="padLeft">ariyet alana ait olacaktır.</span><br></div></div></section> <section class="row mt-3"> <div class="container"> <h6 class="">MADDE 4 – UYUŞMAZLIKLARDA YETKİLİ MAHKEME VE İCRA DAİRELERİ ;</h6> <div class="ml-5"> <div> <span>İş bu sözleşmeden doğması muhtemel uyuşmazlıklar için Denizli mahkemeleri ve icra daireleri yetkili olacaktır.</span><br></div><div class="mt-3"> <span>İş bu sözleşme, …../…../….. Tarihinde iki nüsha olarak imzalanmış ve bir nüsha ariyet alana teslim edilmiş, ikinci nüsha ariyet verene kalmıştır.</span> </div></div></div></section> <section class="row mt-4"> <div class="container d-flex flex-row justify-content-between"> <div class="leftSignature"> <span class="borderBottom"><b>Ariyet alan</b></span> </div><div class="rightSignature"> <span class="borderBottom"><b>Ariyet veren</b></span> </div></div></section> </div></div></div><div class="container" id="thirdPage"> <main class="row"> <div class="container"> <section class="row ml-2"> <div class="container-fluid"> <h5 class=""><b>KİRA ANLAŞMASI HÜKÜM ŞARTLARI</b></h5> <div class=""> <b>BİLGE RENT A CAR’</b> dan kiralamış olduğum aracın bakımı tarafıma aittir. Trafik kurallarına uygun kullanmak ve tehlikesinin bana ait olmak üzere kiraladım. </div></div></section> <section class="row"> <div class="container-fluid"> <div> <span>1-Araç müşteride iken doğacak kazalardan dolayı tamirde kaldığı günler için emniyet tarafından bağlanıldığı için ve sözleşme tarihi</span> <span class="padLeft">geciktiğinde her gün için günlük kira bedelini ödemekle yükümlüdür.</span><br><span>2-Lastik, tampon ve camlarda doğacak hasarlar sigorta kapsamına girmez.</span><br><span>3-Sözleşme maddeleri ne bağlı kalmak için teminat senedi alınmış olup aracın temininden 40 gün sonra iade edilecektir.</span><br><span>4-Kiracı dilerse kazadan muaf olmak için günlük kaza muafiyet sigortası yaptırabilir. 3000 tl ye kadar olan hasarı kendi ödemekle </span> <span class="padLeft">yükümlüdür.</span><br><span>5-Uzatmalar en geç 2 gün önceden belirtilicektir. Aksi takdirde kanuni işlem uygulanacaktır.</span><br><span>6-Kaza halinde alkol ve kaza raporu tutturulması şarttır. Aksi takdirde kanuni işlem uygulanacaktır.</span><br><span>7-Kiralama ücreti peşindir. 3. Şahıslara verilen zararlardan firmamız sorumlu değildir.</span><br><span>8-Aracın hasarlı veya arızalı tesliminde experin belirliyeceği fiyatı kiracı ödemekle yükümlüdür. Aksi taktirde teminat senedi geçerlidir.</span><br><span>9-Kiracı kiraladığı aracı başkasına verirse doğrudan kiracı sorumlu olur.</span><br><span>10-Aracın müşteride iken çalınması durumunda, polis zabtının tanziminden, sigorta aracın bedelini ödemesine kadar geçen her gün için </span> <span class="padLeft">....... Tl tahsil edilir.</span><br><span>11-Otomobilin müşteride olduğu süre içersinde (ileride çıkacak olursa) bile tüm maddi ve manevi tazminat bedelleri otomobili </span> <spa class="padLeft"n>kiralayana aittir.</span><br><span>12-Müşteri kiraladığı otomobili sürenin bitiminde getirmediği taktirde her geçen gün için müşteri …… TL ödemeyi taahhüt eder.</span><br><span>13-Aracı kiralayanın dışında başka şahıslar kullanacaksa bu kişi ile ilgili bilgiler kayıt edilecektir.</span><br><span>14-Trafik cezası müşteriye aittir. Müşteri aracı teslim ettikten sonra kiraladığı günler dahilinde aracın arkasından trafik cezası kesilmişse </span> <span class="padLeft">kiracı trafik cezasını ödemekle yükümlüdür.</span><br><span>15-Gecikmelerse saat başı …… TL alınır.</span><br><span>16-Kaza halinde aracın yerini değiştirmeden en yakın polis karakoluna başvurarak kaza ve alkol raporu alınız.</span><br><span>17-Sigorta kapsamına girmeyen hasar ve tazminat bedelleri müşteriye aittir.</span><br><span>18-Aracı kiraya verilen 3. Şahıslara zarar veren kaza sonucu doğacak hukuki sorumluluğun her araç için aksedilmiş ihtiyari mali </span> <span class="padLeft">mesuliyet sigortası dahilinde katılmak şartıyla, sigorta şirketinden istifade ettiği tazminat miktarında yüklenir. Bu hallerin üzerindeki </span> <span class="padLeft">hukuki sorumluluk müşteriye aittir, tarafça okunup imzalanmıştır.</span><br><span>19-Kiracı aracı iyi ve sağlam durumda teslim almıştır ve kira süresi içerisinde tüketilen yakıt kiracıya aittir. Kiracı sağlam durumda teslim </span> <span class="padLeft">aldığı araçta kullanım hatası nedeni ile dikkatsizlik, tedbirsizlik nedeni ile oluşan ve genel sigorta kuralları kapsamında sigorta </span> <span class="padLeft"> firmalarının talep ve tahsil edilemeyen her türlü mekanik, elektirk ve sair tüm zarar ve ziyanları ile talepte ödemeyi kabul ve taahhüt</span> <span class="padLeft">ederim. (örneğin hatalı vites değiştirmesi nedeni ile şanzıman dağılması aracın altının veya diğer yerlerinin hasarlanması jant ve</span> <span class="padLeft">lastik gibi akşamlara zarar verilmesi)</span><br><span>20-Vasıta aşağıdaki amaçlar için kullanılmayacaktır.</span><br><span class="padLeft">a)Gümrük ve mevzuatı ve diğer kanunlara aykırı maddelerin taşınmasında</span><br><span class="padLeft">b)Açık ve gizli gelir karşılığı yolcu ve yük taşınmasında</span><br><span class="padLeft">c)Herhangi bir vasıtayı çekmek ve itmekte</span><br><span class="padLeft">d)Alkol ve uyuşturucu madde almış şekilde</span><br><span class="padLeft">e)Kiralıyanın yazılı izni dışında türkiye dışında</span><br><span class="padLeft">f)Otomobil trafiğe açık ve müsait olmayan yerlerde</span><br><span class="padLeft">g)Yük ve yolcu bakımından fabrikanın koyduğu sınırlar dışında</span><br><span>21-Kiracı kiralayanın isteği üzerine aşağıda belirtilenleri ödemekle yükümlüdür.</span><br><span class="padLeft">a)Ön sayfada belirtilen miktarda miktarlar üzerinden gündelik ücret, kasko, sigorta, muafiyet primi, ferdi kaza ücreti ve diğer ücretler</span><br><span class="padLeft">b)Araç denizli dışarısında bir yere bırakılmışsa kira kiralanan</span><br><span class="padLeft">c)Kdv vs. diğer tahakkuk edilecek vergiler</span><br><span class="padLeft">d)Kiralama süresi içerisinde trafik cezaları</span><br><span class="padLeft">e)Çarpışma ve devrilmesi neticesindeki, kiralayanın yapacağı masraflar</span><br><span>22-Kiracı vasıtayı kiralayana teslim ettiği anda ve sonrasında kendi veya bir başkası tarafından vasıta içerisinde unutulan herhangi bir </span> <span class="padLeft">eşya veya benzeri cisimlerden sorumlu tutulmayacaktır.</span><br><span>23-Kiralayan vasıtayı bakımlı ve arızasız bir vaziyette kiracıya teslim edecek ve herhangi bir mekanik hata ve arızada doğa bilecek veya </span> <span class="padLeft">bunların sonucu olabilecek bir zarar veya hasarda sorumlu tutulmayacaktır. Kiracı kullanmadığı zamanlarda vasıtayı daima kilitli </span> <span class="padLeft">tutacaktır.</span><br><span>24-Kiracı kiralayanın defter kayıtlarını ve belgelerin geçerli ve yeterli kanuni delil olduğunu peşinen kabul eder.</span><br><span>25-İş bu anlaşmadan doğacak ihtilaflarda TC karayolları, denizli mahkeme ve icra daireleri yetkilidir.</span><br><span>26-Kiracı kaza yaptıktan sonra aracın serviste kaldığı gün kadar kiralama bedelini vermekle yükümlüdür.</span><br><span>27-Kiracı 2918 sayılı karayolları trafik kanunu hükümleri dairesinde sözleşmeye konu araçların uzun süreli kiralanması ve fiili tasarruf altına</span> <span class="padLeft">alınması sebebi ile işletilen sıfatına haizdir. Dolayısıyla kira süresinde vukuu bulacak her türlü trafik kazası nedeni ile gerek araçta meydana</span> <span class="padLeft">gelen hasarın ve gerekse 3. Kişilerin maddi ve manevi hak taleplerini kasko ve zorunlu trafik sigortası poliçelerinin karşılamadığı kısımdan</span> <span class="padLeft">kiracı sorumludur. Sözleşme sona ermiş ve araç teslim edilmiş olsa dahi kiracı sözleşme süresi içerisinde sorumlu olduğu masrafları ve </span> <span class="padLeft"> giderleri ödemekle yükümlüdür</span> </div></div></section> <section class="row mt-3"> <div class="container d-flex flex-row justify-content-between"> <div class=""> <span>KİRALAYAN</span> </div><div class=""> <span>KİRACI</span> </div><div class=""> <span>KEFİL </span> </div></div></section> </div></main> </div></div></body></html>';
        printHtml = printHtml.replaceAll('<![CDATA[CONTEXTPATH]]>','http://${config.getProjectUrl()}/');
        print(printHtml);
    }
</script>
<!-- //END JS DYNAMIC PRINT-